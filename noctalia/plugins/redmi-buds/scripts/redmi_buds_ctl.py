#!/usr/bin/env python3
"""
Redmi Buds 8 Lite Control & Telemetry Script
Engineered by Hatsune Miku for Saviour Gundam (Comrade Patata)
"""

import sys
import os
import json
import socket
import time

MAC_ADDRESS = "A0:90:B5:23:6C:F2"
CHANNEL = 17
STATE_FILE = os.path.expanduser("~/.cache/redmi_buds_state.json")

ANC_MODES = {
    0: "Off",
    1: "ANC",
    2: "Transparency"
}

def get_saved_anc_mode():
    try:
        if os.path.exists(STATE_FILE):
            with open(STATE_FILE, "r") as f:
                data = json.load(f)
                return data.get("anc", 1)
    except Exception:
        pass
    return 1  # Default to ANC

def save_anc_mode(mode):
    try:
        os.makedirs(os.path.dirname(STATE_FILE), exist_ok=True)
        with open(STATE_FILE, "w") as f:
            json.dump({"anc": mode, "anc_name": ANC_MODES.get(mode, "Unknown"), "updated_at": time.time()}, f)
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

def get_battery_info(mac=MAC_ADDRESS, channel=CHANNEL, timeout=1.5):
    if not is_bluez_connected(mac):
        return {"connected": False}

    s = socket.socket(socket.AF_BLUETOOTH, socket.SOCK_STREAM, socket.BTPROTO_RFCOMM)
    s.settimeout(timeout)
    try:
        s.connect((mac, channel))
        # Send device info request
        req = bytes.fromhex('fedcbac402000501ffffffffef')
        s.send(req)

        deadline = time.time() + timeout
        while time.time() < deadline:
            try:
                chunk = s.recv(1024)
                if not chunk:
                    break
                # Find battery TLV tag: 03 03 00 03 <left> <right> <case>
                for i in range(len(chunk) - 6):
                    if chunk[i] == 0x03 and chunk[i+1] == 0x03 and chunk[i+2] == 0x00 and chunk[i+3] == 0x03:
                        l_raw = chunk[i+4]
                        r_raw = chunk[i+5]
                        c_raw = chunk[i+6]

                        left = l_raw & 0x7F
                        left_charging = bool(l_raw & 0x80)

                        right = r_raw & 0x7F
                        right_charging = bool(r_raw & 0x80)

                        case = c_raw & 0x7F
                        case_charging = bool(c_raw & 0x80)

                        anc = get_saved_anc_mode()
                        anc_label = ANC_MODES.get(anc, "ANC")

                        l_str = f"{left}%" + ("⚡" if left_charging else "")
                        r_str = f"{right}%" + ("⚡" if right_charging else "")
                        c_str = f"{case}%" + ("⚡" if case_charging else "")

                        return {
                            "connected": True,
                            "left": left,
                            "left_charging": left_charging,
                            "right": right,
                            "right_charging": right_charging,
                            "case": case,
                            "case_charging": case_charging,
                            "anc": anc,
                            "anc_name": anc_label,
                            "text": f"L:{l_str} R:{r_str} · {anc_label}",
                            "tooltip": f"🎧 REDMI Buds 8 Lite\nLeft: {l_str}\nRight: {r_str}\nCase: {c_str}\nMode: {anc_label}\n\n• Left-click: Open details panel\n• Right-click: Toggle ANC mode"
                        }
            except socket.timeout:
                break
        return {"connected": True, "error": "battery_tlv_not_found"}
    except Exception as e:
        return {"connected": False, "error": str(e)}
    finally:
        s.close()

def set_anc(mode, mac=MAC_ADDRESS, channel=CHANNEL, timeout=2.0):
    if not is_bluez_connected(mac):
        return {"ok": False, "error": "not_connected"}

    s = socket.socket(socket.AF_BLUETOOTH, socket.SOCK_STREAM, socket.BTPROTO_RFCOMM)
    s.settimeout(timeout)
    try:
        s.connect((mac, channel))
        # fe dc ba c4 08 00 04 01 02 04 <mode> ef
        pkt = bytes([0xFE, 0xDC, 0xBA, 0xC4, 0x08, 0x00, 0x04, 0x01, 0x02, 0x04, mode & 0xFF, 0xEF])
        s.send(pkt)
        time.sleep(0.15)
        save_anc_mode(mode)
        return {"ok": True, "anc": mode, "anc_name": ANC_MODES.get(mode, "Unknown")}
    except Exception as e:
        return {"ok": False, "error": str(e)}
    finally:
        s.close()

def toggle_anc():
    curr = get_saved_anc_mode()
    # Cycle: 1 (ANC) -> 0 (Off) -> 2 (Transparency) -> 1 (ANC)
    next_mode = 0 if curr == 1 else (2 if curr == 0 else 1)
    res = set_anc(next_mode)
    return res

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
