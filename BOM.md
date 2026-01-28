# 📋 Bill of Materials - Luna's Baby Mobile

## 🖨️ 3D Printed Parts

### Mechanical Components
| Qty | Part | File | Print Time | Supports |
|-----|------|------|------------|----------|
| 1 | Central Hub | `central_hub.scad` | ~2.5 hrs | No |
| 4 | Arms | `arm.scad` | ~1 hr each | No |
| 1 | Ceiling Mount | `ceiling_mount.scad` | ~2 hrs | Yes |
| 1 | Crib Clamp Body | `crib_clamp.scad` | ~3 hrs | Yes* |
| 1 | Crib Clamp Jaw | `crib_clamp.scad` | ~1 hr | Yes* |
| 1 | Clamp Knob | `crib_clamp.scad` | ~30 min | No* |
| 1 | Motor Mount | `motor_mount.scad` | ~1 hr | Minimal |
| 1 | Gearbox Housing | `gear_assembly.scad` | ~1.5 hrs | No |
| 1 | Gearbox Lid | `gear_assembly.scad` | ~20 min | No |
| 1 | Motor Pinion (12T) | `gear_assembly.scad` | ~15 min | No |
| 1 | Output Gear (96T) | `gear_assembly.scad` | ~1 hr | No |
| 1 | Output Shaft | `gear_assembly.scad` | ~15 min | No |

*Only needed if using crib mount*

### Electronics Mounts
| Qty | Part | File | Print Time | Supports |
|-----|------|------|------------|----------|
| 1 | Battery Cradle Mount | `battery_mount.scad` | ~1.5 hrs | No |
| 1 | Switch Panel Mount | `switch_mount.scad` | ~30 min | No |
| 1 | Barrel Jack Mount | `barrel_jack.scad` | ~30 min | No* |
| 1 | PDB Mount (IA005) | `pdb_mount.scad` | ~45 min | No |

*Optional - only needed for wall power*

**Total print time:** ~15-18 hours (depending on mount choice and settings)

**Filament estimate:** ~250-300g PLA/PETG

---

## ⚡ Electronics

### Motor
| Qty | Item | Model | Specifications | Est. Price |
|-----|------|-------|----------------|------------|
| 1 | N20 Worm Gear Motor | B-LA008 | 6V, ~30RPM, single shaft, CW | $4-8 |

**Search terms:** "N20 worm gear motor 6V 25RPM single shaft" or "B-LA008"

**Key specs to verify:**
- Voltage: 6V (range 3-7V OK)
- Speed: 25-34 RPM
- Single shaft output (not dual)
- 4mm D-shaft

### Power Supply Components
| Qty | Item | Model | Specifications | Est. Price |
|-----|------|-------|----------------|------------|
| 1 | 4xAA Battery Case | IA003 | 70×65×19mm, PH2.0 connector | $2-4 |
| 1 | Power Switch Module | XA007 | On/Off, XH2.54 connector, 3A max | $2-3 |
| 1 | Power Distribution Board | IA005 | 53×10×10mm, 1A max, M2 mount | $5.29 |
| 1 | DC Barrel Jack* | XC008 | 5.5×2.1mm, panel mount, 12mm hole | $1-2 |
| 1 | 6V DC Adapter* | - | 5.5×2.1mm plug, 500mA+ | $5-10 |

*Optional - for wall power*

**IA005 Power Distribution Board Includes:**
- USB power cable
- PH2.0-2P wire pair (for battery connection)
- 5× SH1.0 jumper cables (for switches and device outputs)

**IA005 Specifications:**
- Size: 53 × 10 × 10mm, Weight: 3g
- Max current: 1A per channel, Max voltage: 7.4V
- Connectors: IN/OUT (PH2.0-2P), SW0-4 (SH1.0-2P), CH1-4 (SH1.0-2P)
- SW0 acts as master switch controlling all outputs
- White LED indicator (off = overcurrent protection triggered)

### Wiring & Connectors
| Qty | Item | Specifications | Est. Price |
|-----|------|----------------|------------|
| 1 | PH2.0 to XH2.54 Adapter | 2-pin, 100-150mm | $1-2 |
| 2ft | 22-24 AWG Wire | Stranded, red & black | $2-3 |
| - | Heat Shrink Tubing | Assorted sizes | $3-5 |
| 2 | JST XH2.54 Connectors | 2-pin, male | $1-2 |

**Note:** The battery case (PH2.0) and switch (XH2.54) use different connectors. You'll need an adapter cable or make your own connections.

---

## 🔩 Bearings

| Qty | Item | Specifications | Est. Price |
|-----|------|----------------|------------|
| 2 | 608 Bearing | 8×22×7mm, standard | $5-8 (pack of 10) |

*Standard skateboard bearings - very common and cheap!*

---

## 🔧 Hardware

### Fasteners
| Qty | Item | Use | Est. Price |
|-----|------|-----|------------|
| 4 | M3 × 10mm Screw | Motor mount, electronics | $2-3 |
| 4 | M4 × 20mm Screw | Ceiling mount | $2-3 |
| 4 | M4 Wall Anchors | Ceiling (drywall) | $3-5 |
| 1 | M6 × 60mm Bolt | Crib clamp adjustment* | $1-2 |
| 1 | M6 Nut | Crib clamp* | $0.50 |
| 1 | M6 Wing Nut | Easier adjustment* | $1 |
| 4 | M2.5 × 8mm Screw | Gearbox lid | $1-2 |

*Only for crib mount option*

---

## 🎨 Decorative Elements (Optional)

### Mobile Hanging Elements
| Qty | Item | Suggestions | Est. Price |
|-----|------|-------------|------------|
| 4-8 | Felt Shapes | Stars ⭐, moons 🌙, clouds ☁️, hearts ❤️ | $5-15 |
| 4-8 | Wooden Beads | 20-30mm, natural or painted | $5-10 |
| - | Pom Poms | Various sizes and colors | $3-5 |
| 1 | Fishing Line | 10-20lb test, clear | $3-5 |
| 1 | Embroidery Thread | For hanging elements | $2-3 |

### Finishing (Optional)
| Qty | Item | Use | Est. Price |
|-----|------|-----|------------|
| 1 | Sandpaper | 220-400 grit | $3-5 |
| 1 | Primer | For painting | $5-8 |
| 1 | Acrylic Paint | Baby-safe, water-based | $3-5 |
| 1 | Clear Coat | Protective finish | $5-8 |

---

## 🛡️ Safety Items

| Qty | Item | Purpose | Est. Price |
|-----|------|---------|------------|
| 4 | Rubber Pads | Crib clamp grip | $3-5 |
| 1 | Cord Cover | Hide power cable | $5-10 |
| 1 | Cord Shortener | Keep cord safe | $3-5 |

---

## 💰 Cost Summary

| Category | Basic | With Decorations |
|----------|-------|------------------|
| Filament (~300g) | $6-10 | $6-10 |
| Motor | $4-8 | $4-8 |
| Bearings | $5-8 | $5-8 |
| Battery Case | $2-4 | $2-4 |
| Switch | $2-3 | $2-3 |
| Power Distribution Board (IA005) | $5-6 | $5-6 |
| Barrel Jack + Adapter | $6-12 | $6-12 |
| Connectors/Wire | $5-10 | $5-10 |
| Fasteners | $8-12 | $8-12 |
| Decorative | - | $15-35 |
| Safety Items | $10-20 | $10-20 |
| **Total** | **$55-90** | **$70-125** |

---

## 🔗 Suggested Suppliers

### Electronics & Motors
| Supplier | Notes |
|----------|-------|
| AliExpress | Best prices, 2-4 week shipping |
| Amazon | Fast shipping, higher prices |
| Banggood | Good selection, moderate shipping |
| Adafruit/SparkFun | Quality, US-based, premium prices |

### Hardware
| Supplier | Notes |
|----------|-------|
| Home Depot / Lowes | Local, immediate |
| McMaster-Carr | Professional quality |
| Amazon | Convenience, variety packs |
| Bolt Depot | Specialty fasteners |

### 3D Printing Supplies
| Supplier | Notes |
|----------|-------|
| Prusa | Quality filament |
| Overture | Good value on Amazon |
| Hatchbox | Popular, reliable |
| eSUN | Budget-friendly |

### Craft Supplies
| Supplier | Notes |
|----------|-------|
| Michaels / Joann | Local craft stores |
| Etsy | Handmade mobile elements |
| Amazon | Bulk supplies |

---

## 📝 Notes

### Motor Selection
The B-LA008 is the recommended motor. Key differences from the old design:
- **Old (B-LA009):** Dual shaft, 150 RPM @ 3V
- **New (B-LA008):** Single shaft, ~30 RPM @ 6V

The slower motor with single shaft simplifies the design significantly!

### Power Considerations
| Power Source | Voltage | Runtime | Notes |
|--------------|---------|---------|-------|
| 4× AA Alkaline | 6V | 40-60 hrs | Portable, no wires |
| 4× AA Rechargeable | 4.8V | 30-50 hrs | Slightly slower rotation |
| 6V DC Adapter | 6V | Unlimited | Requires outlet nearby |

### Connector Compatibility
```
Battery Case (IA003) → PH2.0 connector
Switch (XA007)      → XH2.54 connector
```

These are different connector families! Solutions:
1. **Buy an adapter cable** - Search "JST PH2.0 to XH2.54"
2. **Make your own** - Cut and solder/crimp
3. **Bypass connectors** - Solder wires directly

### Battery Life Calculation
```
Motor current: ~30mA
AA battery capacity: ~2000mAh (alkaline)
Runtime: 2000 ÷ 30 = ~66 hours theoretical
Real-world: ~40-60 hours (accounting for losses)
```

---

## 🌙 For Luna

This mobile was designed with love for Jeremy's newborn daughter Luna. May the gentle rotation and soft decorations bring her peaceful dreams!

💕 Made with care, powered by coffee ☕
