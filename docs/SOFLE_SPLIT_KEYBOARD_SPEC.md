# Sofle Split Ergonomic Keyboard — Engineering & Build Specification

A low-profile / column-staggered split keyboard specification with dual rotary encoders, I2C OLED displays, and open-source QMK/ZMK firmware.

---

## 1. Hardware Architecture

```
[ Left Half ]                                    [ Right Half ]
+-------------------------+                      +-------------------------+
| [OLED]      [Encoder]   |                      | [Encoder]      [OLED]   |
| 128x32 I2C  EC11 Knob   |                      | EC11 Knob   128x32 I2C  |
|                         |                      |                         |
| Pro Micro RP2040 (MCU)  | <== TRRS 4-Core ==>  | Pro Micro RP2040 (MCU)  |
| 58 Keys (Col-Stagger)   |   (VCC/GND/TX/RX)    | 58 Keys (Col-Stagger)   |
| Kailh Choc V1 Hotswap   |                      | Kailh Choc V1 Hotswap   |
+-------------------------+                      +-------------------------+
            ||                                               
      [USB-C to Host]
```

### 1.1 Form Factor & Layout
* **Layout:** Sofle v2 or Sofle Choc (58 keys total, 4x6 per half + 5 thumb keys per side).
* **Key Stagger:** Columnar (vertical offset matching anatomical finger reach; zero diagonal typewriter stagger).
* **Inter-Half Bus:** 3.5mm TRRS cable carrying `VCC`, `GND`, and serial UART (`TX`/`RX`).
* **Host Interface:** USB-C via primary (master) MCU.

---

## 2. Bill of Materials (BOM) & Sourcing Specification

| Component | Part / Spec | Quantity | Notes |
| :--- | :--- | :--- | :--- |
| **PCBs** | Sofle v2 (MX) or Sofle Choc (Low Profile) | 1 pair (L/R) | Reversible or dedicated L/R FR4 boards |
| **Plates & Bottom** | Top switch plate + Bottom FR4 baseplate | 1 pair (L/R) | With M2 standoffs & brass screws |
| **Microcontroller** | RP2040 Pro Micro (USB-C) | 2 pcs | 133MHz Dual-core ARM, 16MB Flash, Type-C |
| **Diodes** | 1N4148W (SOD-123 surface-mount) | 60 pcs | Anti-ghosting matrix diodes (directional) |
| **Hotswap Sockets** | Kailh Choc v1 (or Kailh MX) | 60 pcs | SMD sockets for solderless switch replacement |
| **Rotary Encoders** | Bourns / Alps EC11 with push-button | 2 pcs | D-shaft, 15mm or 20mm with metal knobs |
| **OLED Displays** | 0.91" (128x32) or 0.96" (128x64) I2C SSD1306 | 2 pcs | 4-pin (`VCC`, `GND`, `SCL`, `SDA`) |
| **Reset Switches** | 2-pin SMD momentary tactile button | 2 pcs | Micro-switch for bootloader entry |
| **TRRS Jacks** | PJ-320A 3.5mm 4-pole phone jacks | 2 pcs | SMD/THT PCB mount |
| **TRRS Cable** | 3.5mm 4-pole male-to-male audio cable | 1 pc | Straight or coiled (do NOT unplug while powered) |
| **Switches** | Kailh Choc v1 Linear (Red 50g / Pro Red 35g) | ~60 pcs | Low travel (~1.5mm actuation, 3.0mm total) |
| **Keycaps** | 1u Choc keycaps (MBK, MCC, or uniform DSA/XDA) | ~60 pcs | Uniform profile required for ortholinear layout |
| **Rubber Feet** | 3M silicone bump-ons | 8-10 pcs | Prevents slipping and desk shorting |

---

## 3. Assembly & Hardware Implementation

### 3.1 Soldering Order of Operations
1. **Diodes (SMD 1N4148W):**
   * Identify cathode marking (the white/silver stripe on the component body).
   * Match cathode stripe to the line printed on the PCB silkscreen footprint.
   * Method: Tin one pad, slide diode in with tweezers, reflow, then solder the opposite pad.
2. **Kailh Hotswap Sockets:**
   * Align socket over the two through-holes on the back of the PCB.
   * Flood both terminal pads with solder. Ensure mechanical contact is flush with PCB surface.
3. **TRRS Jack & Reset Tactile Switch:**
   * Solder through-hole pins on the component side specified by the PCB documentation.
4. **I2C OLED Jumpers & Sockets:**
   * Bridge the I2C configuration solder jumpers on the PCB surface (if required by PCB revision).
   * Install female SIP sockets or pin headers for display mounting.
5. **Rotary Encoders (EC11):**
   * Clip stability mounting tabs if the PCB does not have wide routing holes. Solder the 3 encoder pins and 2 switch pins.
6. **MCU Installation:**
   * Socket the RP2040 boards using diode-leg pins or machine-pin headers (allows removal if a port or chip fails).
   * Orient MCU face-down or face-up according to silkscreen guidelines for that specific half.

> [!CAUTION]
> Never plug or unplug the 3.5mm TRRS interconnect cable while the USB cable is plugged into host power. Doing so shorts `VCC` across the data pins and can brick the RP2040 GPIO controllers.

---

## 4. Software & Firmware Configuration (QMK)

### 4.1 Toolchain Setup (Fedora Linux)
Install the QMK CLI and ARM cross-compilation toolchain:

```bash
sudo dnf install -y git gcc-arm-linux-gnu arm-none-eabi-newlib python3-pip
pip install --user qmk
qmk setup
```

### 4.2 Rules Configuration (`rules.mk`)
Enable OLED and Encoder hardware drivers in the keyboard keymap folder:

```make
MCU = RP2040
BOOTLOADER = rp2040

BOOTMAGIC_ENABLE = yes
MOUSEKEY_ENABLE = yes
EXTRAKEY_ENABLE = yes
CONSOLE_ENABLE = no
COMMAND_ENABLE = no
BACKLIGHT_ENABLE = no
RGBLIGHT_ENABLE = no

ENCODER_ENABLE = yes
OLED_ENABLE = yes
OLED_DRIVER = SSD1306
LTO_ENABLE = yes
```

### 4.3 Rotary Encoder Implementation (`config.h` & `keymap.c`)
In `config.h`:
```c
#define ENCODERS_PAD_A { GP26 }
#define ENCODERS_PAD_B { GP27 }
#define ENCODER_RESOLUTION 4
```

In `keymap.c`:
```c
bool encoder_update_user(uint8_t index, bool clockwise) {
    if (index == 0) {
        // Left Half: Volume Control
        if (clockwise) {
            tap_code(KC_VOLU);
        } else {
            tap_code(KC_VOLD);
        }
    } else if (index == 1) {
        // Right Half: Page Scrolling / Window Switching
        if (clockwise) {
            tap_code(KC_PGDN);
        } else {
            tap_code(KC_PGUP);
        }
    }
    return true;
}
```

---

## 5. OLED Display & Custom Bitmap Rendering

The SSD1306 display is controlled via I2C. Frames are written as raw byte arrays directly to the display buffer.

### 5.1 Bitmap Asset Pipeline
1. Create a 32x32 (or 128x32) monochrome image (1-bit black and white, `#000000` and `#FFFFFF`).
2. Export image to single-frame C byte array using [image2cpp](https://javl.github.io/image2cpp/) (Horizontal, 1 bit per pixel).
3. Store frame sequences in PROGMEM.

### 5.2 Animated Bitmap Routine (`keymap.c`)
```c
#ifdef OLED_ENABLE

static const char PROGMEM char_dance[2][32] = {
    {
        0x00, 0x18, 0x3c, 0x7e, 0x18, 0x18, 0x3c, 0x42, // Frame 1
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    },
    {
        0x00, 0x18, 0x3c, 0x7e, 0x18, 0x24, 0x42, 0x81, // Frame 2
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00,
        0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00, 0x00
    }
};

oled_rotation_t oled_init_user(oled_rotation_t rotation) {
    return OLED_ROTATION_270; // Rotate 270 deg for vertical reading on split boards
}

bool oled_task_user(void) {
    if (is_keyboard_master()) {
        // Master side: Layer and OS status telemetry
        oled_write_P(PSTR("LAYER\n"), false);
        switch (get_highest_layer(layer_state)) {
            case 0:
                oled_write_P(PSTR("BASE\n"), false);
                break;
            case 1:
                oled_write_P(PSTR("NAV \n"), false);
                break;
            case 2:
                oled_write_P(PSTR("HYPR\n"), false);
                break;
            default:
                oled_write_P(PSTR("MISC\n"), false);
                break;
        }
        // WPM Telemetry readout
        oled_write_P(PSTR("WPM: "), false);
        oled_write(get_current_wpm(), false);
    } else {
        // Slave side: Animation Loop
        static uint32_t anim_timer = 0;
        static uint8_t  anim_frame = 0;

        if (timer_elapsed32(anim_timer) > 200) { // 200ms frame time
            anim_timer = timer_read32();
            anim_frame = (anim_frame + 1) % 2;
            oled_write_raw_P(char_dance[anim_frame], sizeof(char_dance[anim_frame]));
        }
    }
    return false;
}
#endif
```

---

## 6. Flashing & Compilation

1. Enter RP2040 Bootloader Mode: Hold physical reset / boot button on the MCU while connecting USB-C (mounts as mass-storage device `RPI-RP2`).
2. Compile and flash Left (Master):
   ```bash
   qmk compile -kb sofle_choc -km default
   # Copy the generated .uf2 firmware directly into the mounted RPI-RP2 drive
   cp build/sofle_choc_default.uf2 /run/media/$USER/RPI-RP2/
   ```
3. Repeat step 1 and 2 for Right (Slave) controller.
4. Connect TRRS cable between halves, plug USB-C into Left side, verify matrix with `evtest` or browser-based key tester.
