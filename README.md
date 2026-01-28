# 🌙 Luna's Baby Mobile

A beautiful, motorized baby mobile designed for 3D printing. This project creates a gently rotating mobile that can be mounted to a ceiling or crib rail.

## ✨ Features

- **Motorized rotation** - Gentle ~3.75 RPM rotation using an N20 worm gear motor
- **Simple design** - Single-stage gear reduction (8:1) for reliability
- **Two mounting options** - Ceiling mount or adjustable crib rail clamp
- **Modular design** - 4 interchangeable arms with various hook styles
- **Dual power options** - 4xAA battery pack OR DC barrel jack for wall power
- **Baby-safe** - Rounded edges, no pinch points, secure mounting
- **Fully parametric** - Easy to customize dimensions in OpenSCAD
- **Easy assembly** - Press-fit and snap-fit connections

## 📦 What's Included

### OpenSCAD Files
| File | Description |
|------|-------------|
| `config.scad` | All parameters and dimensions |
| `gears.scad` | Involute gear generation library |
| `motor_mount.scad` | N20 motor housing (single shaft version) |
| `gear_assembly.scad` | Single-stage gear reduction (8:1) |
| `central_hub.scad` | Main hub with bearing seat |
| `arm.scad` | Arms with decorative hooks |
| `ceiling_mount.scad` | Ceiling mounting bracket |
| `crib_clamp.scad` | Adjustable crib rail clamp |
| `battery_mount.scad` | 4xAA battery case holder |
| `switch_mount.scad` | Power switch bracket |
| `barrel_jack.scad` | DC barrel jack mount |
| `pdb_mount.scad` | Power Distribution Board (IA005) mount |
| `assembly.scad` | Complete assembly visualization |

### Pre-rendered STL Files
Located in `openscad/stl/` for immediate printing.

## 🔧 Specifications

### Motor (N20 Worm Gear - B-LA008, Single Shaft)
| Parameter | Value |
|-----------|-------|
| Voltage | 6V DC (range: 3-7V) |
| Speed | ~30 RPM @ 6V |
| Shaft | Single, 4mm with D-flat |
| Current | ≤30mA |
| Direction | Clockwise |

### Bearing (608)
| Parameter | Value |
|-----------|-------|
| Inner diameter | 8mm |
| Outer diameter | 22mm |
| Width | 7mm |

### Gear Reduction (Simplified!)
| Stage | Pinion | Gear | Ratio | Input RPM | Output RPM |
|-------|--------|------|-------|-----------|------------|
| Single | 12T | 96T | 8:1 | ~30 | **~3.75** |

*Much simpler than the previous two-stage 50:1 design!*

### Power Options

**Option 1: Battery Power (4xAA)**
| Parameter | Value |
|-----------|-------|
| Voltage | 6V (4 × 1.5V) |
| Battery Case | IA003 (70×65×19mm) |
| Connector | PH2.0 |
| Runtime | ~40-60 hours |

**Option 2: Wall Power (DC Adapter)**
| Parameter | Value |
|-----------|-------|
| Voltage | 6V DC |
| Jack | 5.5×2.1mm barrel |
| Current | 500mA+ recommended |

## 🛒 Bill of Materials

See [BOM.md](BOM.md) for the complete parts list with links and prices.

### Quick Parts List
- 1× N20 Worm Gear Motor (6V, ~30RPM, B-LA008)
- 2× 608 Bearings
- 1× 4xAA Battery Case (IA003, PH2.0)
- 1× Power Switch (XA007, XH2.54)
- 1× DC Barrel Jack (optional, XC008)
- Fasteners (M3, M4 screws)
- Wire, connectors

## 🖨️ Printing Guidelines

### Recommended Settings
| Setting | Value |
|---------|-------|
| Layer height | 0.2mm |
| Infill | 20-30% |
| Material | PLA or PETG |
| Supports | Only where noted |

### Print Times (approximate)
| Part | Time | Supports |
|------|------|----------|
| Central Hub | 2-3 hours | No |
| Arms (×4) | 1 hour each | No |
| Ceiling Mount | 2 hours | Yes |
| Crib Clamp | 3-4 hours | Yes |
| Motor Mount | 1 hour | Minimal |
| Gear Housing | 1.5 hours | No |
| Motor Pinion | 15 min | No |
| Output Gear | 1 hour | No |
| Battery Mount | 1.5 hours | No |
| Switch Mount | 30 min | No |
| Barrel Jack Mount | 30 min | No |

### Tolerances
Adjust in `config.scad` if needed:
- Press fit: 0.15mm
- Loose fit: 0.3mm
- General: 0.2mm

## 🔨 Assembly Instructions

### 1. Print All Parts
Use the settings above. Check each part for quality before assembly.

### 2. Install Bearings
Press 608 bearings into:
- Ceiling mount (or crib clamp) bearing seat
- Gear housing output shaft position

### 3. Assemble Gear Train (Simplified!)
1. Press motor pinion (12T) onto motor D-shaft
2. Mount output gear (96T) on output shaft with bearing
3. Install gear housing with motor pinion engaged
4. Close gearbox with lid

### 4. Attach Motor to Mount
1. Slide motor into motor mount housing
2. Clips will snap over motor body
3. Route wires through exit slot

### 5. Assemble Hub & Arms
1. Insert arms into hub sockets (they snap-fit)
2. Attach hub adapter through bearing to output gear
3. Verify smooth rotation

### 6. Mount Assembly

**Ceiling Mount:**
1. Mark ceiling holes using mount as template
2. Install wall anchors if needed
3. Secure mount with M4 screws
4. Attach motor/gearbox assembly
5. Hang hub assembly

**Crib Clamp:**
1. Position clamp on crib rail
2. Tighten adjustment knob
3. Verify secure grip (no movement)
4. Attach mobile assembly

### 7. Electronics Assembly

**Wiring with Power Distribution Board (IA005):**

The IA005 provides clean power management with overcurrent protection and multiple outputs.

```
┌─────────────────────────────────────────────────────────────────────────┐
│                    POWER DISTRIBUTION WIRING                            │
├─────────────────────────────────────────────────────────────────────────┤
│                                                                         │
│  ┌─────────────┐      ┌─────────────────────────────────┐              │
│  │ 4xAA Battery│─────→│ IN (PH2.0)                      │              │
│  │   (IA003)   │      │                                 │              │
│  │   (PH2.0)   │      │         IA005 PDB               │              │
│  └─────────────┘      │   Power Distribution Board      │              │
│                       │                                 │              │
│  ┌─────────────┐      │ SW0 (SH1.0) ←── Master Switch   │              │
│  │ XA007 Switch│─────→│ (controls all outputs)          │              │
│  │  (XH2.54*)  │      │                                 │              │
│  └─────────────┘      │ CH1 (SH1.0) ───→ Motor ─────────┼──→ 🔄        │
│                       │ CH2 (SH1.0) ───→ (spare)        │              │
│  * May need adapter   │ CH3 (SH1.0) ───→ (spare)        │              │
│    or rewire to SH1.0 │ CH4 (SH1.0) ───→ (spare)        │              │
│                       │                                 │              │
│                       │ 💡 LED: White = OK              │              │
│                       │        Off = Overcurrent        │              │
│                       └─────────────────────────────────┘              │
│                                                                         │
└─────────────────────────────────────────────────────────────────────────┘
```

**Connection Summary:**
| From | To | Cable Type |
|------|----|------------|
| Battery Case (IA003) | IA005 IN | PH2.0-2P (included) |
| IA005 CH1 | Motor | SH1.0-2P (included) |
| XA007 Switch | IA005 SW0 | SH1.0-2P* |

*Note: XA007 switch uses XH2.54 connector. You may need to re-terminate with SH1.0 or use an adapter.

**LED Indicator Behavior:**
- ⚪ **White LED ON** = Normal operation, power flowing
- ⚫ **LED OFF** = Overcurrent protection triggered (>1A), check connections

**Benefits of IA005:**
- ✅ Clean power distribution with labeled ports
- ✅ Overcurrent protection (max 1A per channel)
- ✅ Master switch input (SW0) controls all outputs
- ✅ 4 spare outputs for future accessories (LEDs, sensors, etc.)
- ✅ Easy daisy-chaining via OUT port

**Alternative: Direct Wiring (without PDB)**
```
┌─────────────┐    ┌──────────┐    ┌─────────┐
│ 4xAA Battery│───→│  Switch  │───→│  Motor  │
│   (PH2.0)   │    │ (XH2.54) │    │         │
└─────────────┘    └──────────┘    └─────────┘
```

**Alternative: Wall Power**
```
┌────────────┐    ┌──────────┐    ┌─────────┐
│ DC Adapter │───→│  Switch  │───→│  Motor  │
│ (6V, 5521) │    │ (XH2.54) │    │         │
└────────────┘    └──────────┘    └─────────┘
```

### 8. Add Mobile Elements
Hang decorative elements from arm hooks using string or fishing line.

## ⚠️ Safety Notes

- **Always supervise** - Never leave baby unattended with mobile
- **Height** - Mount at least 16" above mattress (out of reach)
- **Secure mounting** - Test stability before use
- **Regular inspection** - Check for loose parts weekly
- **Age limit** - Remove mobile when baby can push up on hands/knees (~5 months)
- **Cord safety** - Keep power cords away from crib, use cord covers

## 🎨 Customization

### Changing Dimensions
Edit `config.scad` to adjust:
- `arm_length` - Length of arms (default 180mm)
- `hub_arm_count` - Number of arms (default 4)
- `gear_module` - Gear size (affects overall gearbox size)
- `motor_rpm` - If using a different speed motor

### Alternative Hook Styles
In `arm.scad`, choose from:
- Default curved hook
- Loop hook
- Star hook
- Moon hook (🌙 for Luna!)

### Colors
Adjust the color variables in `config.scad` for different preview colors.

## 🔌 Connector Reference

| Component | Connector | Pin Count |
|-----------|-----------|-----------|
| Battery Case | JST PH2.0 | 2-pin |
| Power Switch | XH2.54 | 2-pin |
| DC Barrel Jack | 5.5×2.1mm | 2-wire |
| PDB Power IN/OUT | JST PH2.0 | 2-pin |
| PDB Switch Inputs | JST SH1.0 | 2-pin |
| PDB Device Outputs | JST SH1.0 | 2-pin |

**Adapter cables** may be needed to connect these. Search for "PH2.0 to XH2.54" adapters, or make your own with crimp terminals.

**Note:** The IA005 PDB includes SH1.0 jumper cables, making it easy to connect to motors and switches directly.

## 📝 License

MIT License - See [LICENSE](LICENSE)

Feel free to modify, share, and sell prints!

## 💕 Credits

Designed with love for Luna.

Made for Jeremy's newborn daughter — may she have sweet dreams and endless wonder! 🌙✨

---

*Made with OpenSCAD and lots of coffee ☕*
