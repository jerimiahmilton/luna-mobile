# 🌙 Luna's Baby Mobile

A beautiful, motorized baby mobile designed for 3D printing. This project creates a gently rotating mobile that can be mounted to a ceiling or crib rail.

![Luna's Baby Mobile](docs/preview.png)

## ✨ Features

- **Motorized rotation** - Gentle 3 RPM rotation using an N20 worm gear motor
- **Two mounting options** - Ceiling mount or adjustable crib rail clamp
- **Modular design** - 4 interchangeable arms with various hook styles
- **Baby-safe** - Rounded edges, no pinch points, secure mounting
- **Fully parametric** - Easy to customize dimensions in OpenSCAD
- **Easy assembly** - Press-fit and snap-fit connections

## 📦 What's Included

### OpenSCAD Files
- `config.scad` - All parameters and dimensions
- `gears.scad` - Involute gear generation library
- `motor_mount.scad` - N20 motor housing
- `gear_assembly.scad` - Two-stage gear reduction (50:1)
- `central_hub.scad` - Main hub with bearing seat
- `arm.scad` - Arms with decorative hooks
- `ceiling_mount.scad` - Ceiling mounting bracket
- `crib_clamp.scad` - Adjustable crib rail clamp
- `assembly.scad` - Complete assembly visualization

### Pre-rendered STL Files
Located in `openscad/stl/` for immediate printing.

## 🔧 Specifications

### Motor (N20 Worm Gear - B-LA009)
| Parameter | Value |
|-----------|-------|
| Voltage | 3V DC |
| Speed | 150 RPM |
| Shaft diameter | 4mm (D-flat) |
| Total length | 33.2mm |

### Bearing (608)
| Parameter | Value |
|-----------|-------|
| Inner diameter | 8mm |
| Outer diameter | 22mm |
| Width | 7mm |

### Gear Reduction
| Stage | Ratio | Input RPM | Output RPM |
|-------|-------|-----------|------------|
| 1 | 5:1 | 150 | 30 |
| 2 | 10:1 | 30 | 3 |
| **Total** | **50:1** | **150** | **~3** |

## 🛒 Bill of Materials

See [BOM.md](BOM.md) for the complete parts list.

### Required Components
| Qty | Item | Notes |
|-----|------|-------|
| 1 | N20 Worm Gear Motor (3V, 150RPM) | B-LA009 or equivalent |
| 2-3 | 608 Bearings | Standard skateboard bearings |
| 1 | M6 x 60mm Bolt | For crib clamp (if using) |
| 1 | M6 Nut | For crib clamp |
| 4 | M3 x 10mm Screws | Motor mount |
| 4 | M4 x 20mm Screws | Ceiling mount |
| - | 22-24 AWG Wire | Motor connection |
| 1 | 3V Power Supply | USB adapter or 2xAA battery holder |

### Optional
- Self-adhesive rubber pads (for crib clamp)
- Mobile hanging elements (felt shapes, wooden beads, etc.)
- String or fishing line for hanging elements

## 🖨️ Printing Guidelines

### Recommended Settings
- **Layer height:** 0.2mm
- **Infill:** 20-30%
- **Supports:** Only for ceiling mount and crib clamp
- **Material:** PLA or PETG

### Print Times (approximate)
| Part | Time | Supports |
|------|------|----------|
| Central Hub | 2-3 hours | No |
| Arms (x4) | 1 hour each | No |
| Ceiling Mount | 2 hours | Yes |
| Crib Clamp | 3-4 hours | Yes |
| Motor Mount | 1 hour | Minimal |
| Gears | 2-3 hours total | No |

### Tolerances
Parts are designed with these tolerances (adjust in `config.scad` if needed):
- Press fit: 0.15mm
- Loose fit: 0.3mm
- General: 0.2mm

## 🔨 Assembly Instructions

### 1. Print All Parts
Use the settings above. Check each part for quality before assembly.

### 2. Install Bearings
Press 608 bearings into:
- Ceiling mount (or crib clamp) bearing seat
- Gear assembly housing

### 3. Assemble Gear Train
1. Press motor pinion onto motor shaft (D-flat alignment)
2. Install compound gear on intermediate shaft
3. Mount output gear with hub adapter
4. Close gearbox with lid

### 4. Attach Motor to Mount
1. Slide motor into motor mount housing
2. Route wires through exit slot
3. Secure motor clips

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

### 7. Wire Motor
Connect motor to 3V power supply. Use a switch for easy on/off.

### 8. Add Mobile Elements
Hang decorative elements from arm hooks using string or fishing line.

## ⚠️ Safety Notes

- **Always supervise** - Never leave baby unattended with mobile
- **Height** - Mount at least 16" above mattress (out of reach)
- **Secure mounting** - Test stability before use
- **Regular inspection** - Check for loose parts weekly
- **Age limit** - Remove mobile when baby can push up on hands/knees

## 🎨 Customization

### Changing Dimensions
Edit `config.scad` to adjust:
- `arm_length` - Length of arms (default 180mm)
- `hub_arm_count` - Number of arms (default 4)
- `gear_module` - Gear size (affects overall gearbox size)

### Alternative Hook Styles
In `arm.scad`, choose from:
- Default curved hook
- Loop hook
- Star hook
- Moon hook (🌙 for Luna!)

### Colors
Adjust the color variables in `config.scad` for different preview colors.

## 📝 License

MIT License - See [LICENSE](LICENSE)

Feel free to modify, share, and sell prints!

## 💕 Credits

Designed with love for Luna.

---

*Made with OpenSCAD and lots of coffee ☕*
