# Rendering STL Files

The OpenSCAD files need to be rendered to STL for 3D printing.

## Using OpenSCAD GUI

1. Open any `.scad` file in OpenSCAD
2. Press F6 to render
3. Export → Export as STL

## Command Line Rendering

```bash
# Render individual parts
openscad -o stl/central_hub.stl openscad/central_hub.scad
openscad -o stl/arm.stl openscad/arm.scad
openscad -o stl/ceiling_mount.stl openscad/ceiling_mount.scad
openscad -o stl/motor_mount.stl openscad/motor_mount.scad
openscad -o stl/crib_clamp.stl openscad/crib_clamp.scad

# Render gears (export each part separately by uncommenting in gear_assembly.scad)
openscad -o stl/stage1_pinion.stl -D 'part="pinion1"' openscad/gear_assembly.scad
```

## Recommended Render Settings

For final STL export, increase resolution in `config.scad`:

```openscad
$fn = 128;  // Higher = smoother curves, longer render time
```

## Preview vs Render

- **F5 (Preview)** - Fast, for checking design
- **F6 (Render)** - Full quality, required before STL export
