#!/usr/bin/env python3
"""
Redmi Buds 8 Lite Control & Telemetry Script
Reverse-Engineered by Hatsune Miku for Saviour Gundam (Comrade Patata)
Protocol: Xiaomi RCSP / MIUI SPP (RFCOMM Channel 16/13) & GFPS (Channel 17)
"""

import sys
import os
import json
import socket
import time

MAC_ADDRESS = "A0:90:B5:23:6C:F2"
SPP_CHANNELS = [16, 13]
GFPS_CHANNEL = 17
STATE_FILE = os.path.expanduser("~/.cache/redmi_buds_state.json")

ANC_MODES = {
    0: "Off",
    1: "ANC",
    2: "Transparency"
}

_seq_counter = 1

def get_next_seq():
    global _seq_counter
    _seq_counter = (_seq_counter + 1) & 0x7F
    if _seq_counter == 0:
        _seq_counter = 1
    return _seq_counter

def get_saved_anc_mode():
    try:
        if os.path.exists(STATE_FILE):
            with open(STATE_FILE, "r") as f:
                data = json.load(f)
                return data.get("anc", 1)
    except Exception:
        pass
    return 1

def save_anc_mode(mode):
    try:
        os.makedirs(os.path.dirname(STATE_FILE), exist_ok=True)
        with open(STATE_FILE, "w") as f:
            json.dump({
                "anc": mode,
                "anc_name": ANC_MODES.get(mode, "Unknown"),
                "updated_at": time.time()
            }, f)
    except Exception:
        pass

def is_bluez_connected(mac=MAC_ADDRESS):
    try:
        import dbus
        bus = dbus.SystemBus()
        manager = dbus.Interface(bus.get_object('org.bluez', '/'), 'org.freedesktop.DBus.ObjectManager')
        objects = manager.GetManagedObjects()
        dev_path = '/org/bluez/hci0/dev_' + mac.replace(':', '_')
        if dev_path in objects and 'org.bluez.Device1' in objects[dev_path]:
            return bool(objects[dev_path]['org.bluez.Device1'].get('Connected', False))
    except Exception:
        try:
            import subprocess
            out = subprocess.check_output(["bluetoothctl", "info", mac], stderr=subprocess.DEVNULL).decode()
            return "Connected: yes" in out
        except Exception:
            pass
    return False

def open_rfcomm_socket(mac=MAC_ADDRESS, channels=SPP_CHANNELS, timeout=1.2):
    for ch in channels:
        s = socket.socket(socket.AF_BLUETOOTH, socket.SOCK_STREAM, socket.BTPROTO_RFCOMM)
        s.settimeout(timeout)
        try:
            s.connect((mac, ch))
            return s, ch
        except Exception:
            s.close()
    return None, None

def set_anc(mode, mac=MAC_ADDRESS, timeout=1.5):
    if not is_bluez_connected(mac):
        return {"ok": False, "error": "not_connected"}

    s, ch = open_rfcomm_socket(mac, SPP_CHANNELS, timeout=timeout)
    if not s:
        return {"ok": False, "error": "rfcomm_connect_failed"}

    try:
        sn = get_next_seq()
        # Xiaomi RCSP SetTargetInfo: Opcode 0x08, VendorData: length=0x02, type=0x04, ancType=<mode>
        pkt = bytes([0xFE, 0xDC, 0xBA, 0xC4, 0x08, 0x00, 0x04, sn, 0x02, 0x04, mode & 0xFF, 0xEF])
        s.sendall(pkt)
        time.sleep(0.08)

        # Read responses and ACK any notifications from earbuds
        try:
            while True:
                r = s.recv(1024)
                if not r:
                    break
                idx = 0
                while True:
                    idx = r.find(bytes([0xFE, 0xDC, 0xBA, 0xC7]), idx)
                    if idx == -1:
                        break
                    if idx + 7 < len(r):
                        op = r[idx+4]
                        r_sn = r[idx+7]
                        # Send ACK back to earbud
                        ack = bytes([0xFE, 0xDC, 0xBA, 0x04, op, 0x00, 0x02, 0x00, r_sn, 0xEF])
                        s.sendall(ack)
                    idx += 4
        except socket.timeout:
            pass

        save_anc_mode(mode)
        return {"ok": True, "anc": mode, "anc_name": ANC_MODES.get(mode, "Unknown"), "channel": ch}
    except Exception as e:
        return {"ok": False, "error": str(e)}
    finally:
        s.close()

def toggle_anc():
    curr = get_saved_anc_mode()
    # Cycle: 1 (ANC) -> 2 (Transparency) -> 0 (Off) -> 1 (ANC)
    next_mode = 2 if curr == 1 else (0 if curr == 2 else 1)
    res = set_anc(next_mode)
    return res

def get_battery_info(mac=MAC_ADDRESS, timeout=1.5):
    if not is_bluez_connected(mac):
        return {"connected": False}

    left = None
    right = None
    case = None
    left_charging = False
    right_charging = False
    case_charging = False
    anc_mode = get_saved_anc_mode()

    # Strategy A: Try Channel 16 (MIUI SPP) for full battery + hardware ANC state
    s, ch = open_rfcomm_socket(mac, [16], timeout=0.8)
    if s:
        try:
            # Send inquiry packet
            sn = get_next_seq()
            s.sendall(bytes([0xFE, 0xDC, 0xBA, 0xC4, 0x02, 0x00, 0x05, sn, 0xFF, 0xFF, 0xFF, 0xFF, 0xEF]))
            deadline = time.time() + 0.8
            while time.time() < deadline:
                try:
                    chunk = s.recv(1024)
                    if not chunk:
                        break
                    # Parse CMD_REPORT_DEVICE_STATUS (0x0E)
                    idx = chunk.find(bytes([0xFE, 0xDC, 0xBA, 0xC7, 0x0E]))
                    if idx != -1:
                        # Battery block: 04 00 <left> <right> <case>
                        b_idx = chunk.find(bytes([0x04, 0x00]), idx)
                        if b_idx != -1 and b_idx + 4 < len(chunk):
                            l_raw = chunk[b_idx + 2]
                            r_raw = chunk[b_idx + 3]
                            c_raw = chunk[b_idx + 4]
                            left = l_raw & 0x7F
                            left_charging = bool(l_raw & 0x80)
                            right = r_raw & 0x7F
                            right_charging = bool(r_raw & 0x80)
                            if c_raw != 0xFF:
                                case = c_raw & 0x7F
                                case_charging = bool(c_raw & 0x80)

                        # ANC block: 02 04 <mode>
                        a_idx = chunk.find(bytes([0x02, 0x04]), idx)
                        if a_idx != -1 and a_idx + 2 < len(chunk):
                            anc_mode = chunk[a_idx + 2]
                            save_anc_mode(anc_mode)

                        # Send ACK
                        r_sn = chunk[idx + 7]
                        ack = bytes([0xFE, 0xDC, 0xBA, 0x04, 0x0E, 0x00, 0x02, 0x00, r_sn, 0xEF])
                        s.sendall(ack)
                        break
                except socket.timeout:
                    break
        except Exception:
            pass
        finally:
            s.close()

    # Strategy B: If battery wasn't read, read from Fast Pair (Channel 17)
    if left is None:
        s, ch = open_rfcomm_socket(mac, [GFPS_CHANNEL], timeout=1.0)
        if s:
            try:
                deadline = time.time() + 1.0
                while time.time() < deadline:
                    try:
                        chunk = s.recv(1024)
                        if not chunk:
                            break
                        for i in range(len(chunk) - 6):
                            if chunk[i] == 0x03 and chunk[i+1] == 0x03 and chunk[i+2] == 0x00 and chunk[i+3] == 0x03:
                                l_raw = chunk[i+4]
                                r_raw = chunk[i+5]
                                c_raw = chunk[i+6]
                                left = l_raw & 0x7F
                                left_charging = bool(l_raw & 0x80)
                                right = r_raw & 0x7F
                                right_charging = bool(r_raw & 0x80)
                                if c_raw != 0xFF:
                                    case = c_raw & 0x7F
                                    case_charging = bool(c_raw & 0x80)
                                break
                        if left is not None:
                            break
                    except socket.timeout:
                        break
            except Exception:
                pass
            finally:
                s.close()

    if left is None:
        # Fallback to BlueZ battery property if available
        try:
            import subprocess
            out = subprocess.check_output(["bluetoothctl", "info", mac], stderr=subprocess.DEVNULL).decode()
            for line in out.splitlines():
                if "Battery Percentage:" in line:
                    val = int(line.split("(")[-1].split(")")[0])
                    left = val
                    right = val
        except Exception:
            pass

    if left is None:
        return {"connected": True, "error": "battery_tlv_not_found"}

    anc_label = ANC_MODES.get(anc_mode, "ANC")
    l_str = f"{left}%" + ("⚡" if left_charging else "")
    r_str = f"{right}%" + ("⚡" if right_charging else "")
    c_str = f"{case}%" + ("⚡" if case_charging else "") if case is not None else "--"

    return {
        "connected": True,
        "left": left,
        "left_charging": left_charging,
        "right": right,
        "right_charging": right_charging,
        "case": case,
        "case_charging": case_charging,
        "anc": anc_mode,
        "anc_name": anc_label,
        "text": f"L:{l_str} R:{r_str} · {anc_label}",
        "tooltip": f"🎧 REDMI Buds 8 Lite\nLeft: {l_str}\nRight: {r_str}\nCase: {c_str}\nMode: {anc_label}\n\n• Left-click: Open details panel\n• Right-click: Toggle ANC mode"
    }

if __name__ == "__main__":
    if len(sys.argv) > 1:
        cmd = sys.argv[1]
        if cmd == "status":
            print(json.dumps(get_battery_info()))
        elif cmd == "set-anc":
            mode = int(sys.argv[2]) if len(sys.argv) > 2 else 1
            print(json.dumps(set_anc(mode)))
        elif cmd == "toggle-anc":
            print(json.dumps(toggle_anc()))
        elif cmd == "anc":
            mode = get_saved_anc_mode()
            print(json.dumps({"anc": mode, "anc_name": ANC_MODES.get(mode, "ANC")}))
        else:
            print(json.dumps({"error": f"Unknown command {cmd}"}))
    else:
        print(json.dumps(get_battery_info()))
