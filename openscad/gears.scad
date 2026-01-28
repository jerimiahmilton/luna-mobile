// ============================================================================
// Luna's Baby Mobile - Involute Gear Library
// ============================================================================
// Parametric involute spur gear generation for 3D printing
// Based on standard gear geometry with backlash compensation
// ============================================================================

include <config.scad>

// ----------------------------------------------------------------------------
// INVOLUTE GEAR MODULE
// ----------------------------------------------------------------------------
// Creates a standard involute spur gear
// Parameters:
//   teeth - number of teeth
//   mod - gear module (tooth size)
//   thickness - gear thickness/height
//   bore - center bore diameter (0 for solid)
//   pressure_angle - pressure angle in degrees (typically 20)
//   backlash - backlash amount (reduces tooth thickness)
//   hub_diameter - optional hub diameter (0 for none)
//   hub_height - hub extension height
// ----------------------------------------------------------------------------

module involute_gear(
    teeth = 20,
    mod = 1.5,
    thickness = 8,
    bore = 0,
    pressure_angle = 20,
    backlash = 0.1,
    hub_diameter = 0,
    hub_height = 0
) {
    pitch_r = teeth * mod / 2;
    base_r = pitch_r * cos(pressure_angle);
    outer_r = pitch_r + mod;
    root_r = pitch_r - 1.25 * mod;
    
    // Tooth angular width at pitch circle
    tooth_angle = 180 / teeth;
    
    // Backlash adjustment (reduces tooth width)
    backlash_angle = (backlash / pitch_r) * (180 / PI);
    
    difference() {
        union() {
            // Main gear body
            linear_extrude(height = thickness)
            gear_2d(teeth, mod, pressure_angle, backlash);
            
            // Optional hub
            if (hub_diameter > 0 && hub_height > 0) {
                translate([0, 0, thickness])
                cylinder(d = hub_diameter, h = hub_height);
            }
        }
        
        // Center bore
        if (bore > 0) {
            translate([0, 0, -1])
            cylinder(d = bore, h = thickness + hub_height + 2);
        }
    }
}

// 2D gear profile
module gear_2d(teeth, mod, pressure_angle, backlash) {
    pitch_r = teeth * mod / 2;
    base_r = pitch_r * cos(pressure_angle);
    outer_r = pitch_r + mod;
    root_r = pitch_r - 1.25 * mod;
    
    // Generate gear as polygon
    points = gear_points(teeth, mod, pressure_angle, backlash);
    polygon(points);
}

// Generate gear profile points
function gear_points(teeth, mod, pressure_angle, backlash) =
    let(
        pitch_r = teeth * mod / 2,
        base_r = pitch_r * cos(pressure_angle),
        outer_r = pitch_r + mod,
        root_r = max(pitch_r - 1.25 * mod, base_r),
        tooth_angle = 360 / teeth,
        steps = 8,  // Points per tooth side
        backlash_angle = atan(backlash / pitch_r)
    )
    [
        for (t = [0:teeth-1])
            for (p = tooth_points(t, teeth, mod, pressure_angle, backlash, steps))
                p
    ];

// Points for a single tooth
function tooth_points(tooth_num, teeth, mod, pressure_angle, backlash, steps) =
    let(
        pitch_r = teeth * mod / 2,
        base_r = pitch_r * cos(pressure_angle),
        outer_r = pitch_r + mod,
        root_r = max(pitch_r - 1.25 * mod, base_r * 0.95),
        tooth_angle = 360 / teeth,
        center_angle = tooth_num * tooth_angle,
        backlash_angle = atan(backlash / pitch_r) / 2
    )
    concat(
        // Root on left side
        [[root_r * cos(center_angle - tooth_angle/4 - backlash_angle),
          root_r * sin(center_angle - tooth_angle/4 - backlash_angle)]],
        // Left involute (rising)
        [for (i = [0:steps])
            let(
                t = i / steps,
                r = root_r + t * (outer_r - root_r),
                involute_angle = involute_at_radius(r, base_r, pitch_r, pressure_angle),
                a = center_angle - involute_angle - backlash_angle
            )
            [r * cos(a), r * sin(a)]
        ],
        // Tip
        [[outer_r * cos(center_angle), outer_r * sin(center_angle)]],
        // Right involute (falling)  
        [for (i = [steps:-1:0])
            let(
                t = i / steps,
                r = root_r + t * (outer_r - root_r),
                involute_angle = involute_at_radius(r, base_r, pitch_r, pressure_angle),
                a = center_angle + involute_angle + backlash_angle
            )
            [r * cos(a), r * sin(a)]
        ],
        // Root on right side
        [[root_r * cos(center_angle + tooth_angle/4 + backlash_angle),
          root_r * sin(center_angle + tooth_angle/4 + backlash_angle)]]
    );

// Calculate involute angle at a given radius
function involute_at_radius(r, base_r, pitch_r, pressure_angle) =
    r <= base_r ? 0 :
    let(
        // Involute function: inv(a) = tan(a) - a (in radians)
        // At radius r: cos(angle) = base_r / r
        angle_at_r = acos(base_r / r),
        inv_at_r = tan(angle_at_r) - angle_at_r * PI / 180,
        inv_at_pitch = tan(pressure_angle) - pressure_angle * PI / 180,
        // Angular offset from pitch point
        offset = (inv_at_r - inv_at_pitch) * 180 / PI
    )
    offset;

// ----------------------------------------------------------------------------
// PINION WITH D-SHAFT BORE
// ----------------------------------------------------------------------------
// Small gear designed to fit on motor shaft with D-flat
// ----------------------------------------------------------------------------

module pinion_d_shaft(
    teeth = 10,
    mod = 1.5,
    thickness = 8,
    shaft_diameter = 4,
    flat_depth = 0.5,
    hub_diameter = 0,
    hub_height = 0
) {
    difference() {
        involute_gear(
            teeth = teeth,
            mod = mod,
            thickness = thickness,
            bore = 0,
            pressure_angle = gear_pressure_angle,
            backlash = gear_backlash,
            hub_diameter = hub_diameter,
            hub_height = hub_height
        );
        
        // D-shaft bore
        translate([0, 0, -1])
        linear_extrude(height = thickness + hub_height + 2)
        d_shaft_profile(shaft_diameter + tolerance, flat_depth);
    }
}

// D-shaft profile (circle with flat)
module d_shaft_profile(diameter, flat_depth) {
    intersection() {
        circle(d = diameter);
        translate([-(diameter/2 - flat_depth), -diameter/2])
        square([diameter, diameter]);
    }
}

// ----------------------------------------------------------------------------
// COMPOUND GEAR (two gears on one shaft)
// ----------------------------------------------------------------------------
// Used in multi-stage reduction - large gear and small pinion combined
// ----------------------------------------------------------------------------

module compound_gear(
    large_teeth = 50,
    small_teeth = 10,
    mod = 1.5,
    thickness = 8,
    shaft_bore = 8,
    spacer = 2
) {
    // Large gear on bottom
    involute_gear(
        teeth = large_teeth,
        mod = mod,
        thickness = thickness,
        bore = shaft_bore + tolerance,
        pressure_angle = gear_pressure_angle,
        backlash = gear_backlash
    );
    
    // Small pinion on top
    translate([0, 0, thickness + spacer])
    involute_gear(
        teeth = small_teeth,
        mod = mod,
        thickness = thickness,
        bore = shaft_bore + tolerance,
        pressure_angle = gear_pressure_angle,
        backlash = gear_backlash
    );
    
    // Connecting hub
    translate([0, 0, thickness])
    difference() {
        cylinder(d = small_teeth * mod - 2, h = spacer);
        translate([0, 0, -1])
        cylinder(d = shaft_bore + tolerance, h = spacer + 2);
    }
}

// ----------------------------------------------------------------------------
// RING GEAR (internal gear)
// ----------------------------------------------------------------------------
// For planetary or internal gear arrangements
// ----------------------------------------------------------------------------

module ring_gear(
    teeth = 100,
    mod = 1.5,
    thickness = 8,
    wall = 5,
    pressure_angle = 20,
    backlash = 0.1
) {
    pitch_r = teeth * mod / 2;
    inner_r = pitch_r - mod;
    outer_r = pitch_r + wall;
    
    difference() {
        cylinder(r = outer_r, h = thickness);
        
        translate([0, 0, -1])
        linear_extrude(height = thickness + 2)
        internal_gear_2d(teeth, mod, pressure_angle, backlash);
    }
}

// Internal gear 2D profile (simplified)
module internal_gear_2d(teeth, mod, pressure_angle, backlash) {
    pitch_r = teeth * mod / 2;
    inner_r = pitch_r - 1.25 * mod;
    
    // Simplified internal gear - use offset of external gear
    offset(r = -backlash)
    circle(r = inner_r);
}

// ----------------------------------------------------------------------------
// TEST / PREVIEW
// ----------------------------------------------------------------------------

// Uncomment to preview gears
// involute_gear(teeth = 20, mod = 1.5, thickness = 8, bore = 8);
// translate([40, 0, 0]) pinion_d_shaft(teeth = 10, mod = 1.5, thickness = 8);
// translate([0, 50, 0]) compound_gear(large_teeth = 50, small_teeth = 10);
