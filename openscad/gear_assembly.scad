// ============================================================================
// Luna's Baby Mobile - Gear Reduction Assembly
// ============================================================================
// Two-stage gear reduction: 150 RPM → ~30 RPM → ~3 RPM
// Total reduction ratio: 50:1
// ============================================================================

include <config.scad>
include <gears.scad>

// ----------------------------------------------------------------------------
// GEAR ASSEMBLY HOUSING
// ----------------------------------------------------------------------------
// Enclosed gearbox that houses both stages of reduction
// ----------------------------------------------------------------------------

// Calculate dimensions based on gear sizes
stage1_center_dist = center_distance(pinion1_teeth, gear1_teeth, gear_module);
stage2_center_dist = center_distance(pinion2_teeth, gear2_teeth, gear_module);
gear1_od = outer_diameter(gear1_teeth, gear_module);
gear2_od = outer_diameter(gear2_teeth, gear_module);
pinion1_od = outer_diameter(pinion1_teeth, gear_module);
pinion2_od = outer_diameter(pinion2_teeth, gear_module);

// Housing dimensions
housing_wall = 3;
housing_padding = 5;
shaft_diameter = 8;  // Intermediate shaft (fits bearing inner race)

module gear_housing_base() {
    // Calculate housing size to fit all gears
    max_x = max(gear1_od/2, stage1_center_dist + gear2_od/2) + housing_padding;
    min_x = -pinion1_od/2 - housing_padding;
    max_y = gear2_od/2 + housing_padding;
    min_y = -max(gear1_od/2, gear2_od/2) - housing_padding;
    
    housing_width = max_x - min_x + housing_wall * 2;
    housing_depth = max_y - min_y + housing_wall * 2;
    housing_height = gear_height * 3 + 10;  // Space for both stages + output
    
    // Offset to center
    offset_x = (max_x + min_x) / 2;
    offset_y = (max_y + min_y) / 2;
    
    difference() {
        // Outer shell
        translate([offset_x - housing_width/2, offset_y - housing_depth/2, 0])
        rounded_box(housing_width, housing_depth, housing_height, 5);
        
        // Inner cavity
        translate([offset_x - housing_width/2 + housing_wall, 
                   offset_y - housing_depth/2 + housing_wall, 
                   housing_wall])
        rounded_box(housing_width - housing_wall*2, 
                    housing_depth - housing_wall*2, 
                    housing_height, 3);
        
        // Motor shaft entry hole
        translate([0, 0, -1])
        cylinder(d = motor_shaft_diameter + 2, h = housing_wall + 2);
        
        // Intermediate shaft bearing seat (stage 1 to stage 2)
        translate([stage1_center_dist, 0, -1])
        cylinder(d = bearing_outer_diameter + press_fit_tolerance, h = bearing_width + 1);
        
        translate([stage1_center_dist, 0, housing_height - bearing_width])
        cylinder(d = bearing_outer_diameter + press_fit_tolerance, h = bearing_width + 2);
        
        // Output shaft hole
        translate([stage1_center_dist, stage2_center_dist, housing_height - 1])
        cylinder(d = bearing_outer_diameter + press_fit_tolerance, h = housing_wall + 2);
    }
    
    // Internal bearing posts
    translate([stage1_center_dist, 0, housing_wall])
    bearing_post(bearing_width + 2);
}

// Bearing post - supports intermediate shaft
module bearing_post(height) {
    difference() {
        cylinder(d = bearing_outer_diameter + 6, h = height);
        translate([0, 0, -1])
        cylinder(d = shaft_diameter + tolerance, h = height + 2);
    }
}

// Rounded box helper
module rounded_box(w, d, h, r) {
    hull() {
        for (x = [r, w-r]) {
            for (y = [r, d-r]) {
                translate([x, y, 0])
                cylinder(r = r, h = h);
            }
        }
    }
}

// ----------------------------------------------------------------------------
// INDIVIDUAL GEAR COMPONENTS
// ----------------------------------------------------------------------------

// Stage 1 Pinion - mounts on motor shaft
module stage1_pinion() {
    color(color_gears)
    pinion_d_shaft(
        teeth = pinion1_teeth,
        mod = gear_module,
        thickness = gear_height,
        shaft_diameter = motor_shaft_diameter,
        flat_depth = motor_shaft_flat_depth,
        hub_diameter = pinion1_od - 2,
        hub_height = 3
    );
}

// Stage 1 Gear + Stage 2 Pinion (compound gear)
module stage1_gear_stage2_pinion() {
    color(color_gears)
    compound_gear(
        large_teeth = gear1_teeth,
        small_teeth = pinion2_teeth,
        mod = gear_module,
        thickness = gear_height,
        shaft_bore = shaft_diameter,
        spacer = 2
    );
}

// Stage 2 Output Gear
module stage2_gear() {
    color(color_gears)
    difference() {
        involute_gear(
            teeth = gear2_teeth,
            mod = gear_module,
            thickness = gear_height,
            bore = 0,
            pressure_angle = gear_pressure_angle,
            backlash = gear_backlash,
            hub_diameter = bearing_outer_diameter + 8,
            hub_height = 5
        );
        
        // Bearing seat (output connects to hub)
        translate([0, 0, gear_height - 1])
        cylinder(d = bearing_inner_diameter + press_fit_tolerance, h = 10);
    }
}

// Output shaft adapter - connects gear to central hub
module output_shaft() {
    color(color_gears)
    difference() {
        union() {
            // Main shaft
            cylinder(d = bearing_inner_diameter - press_fit_tolerance, h = 25);
            
            // Flange for gear attachment
            cylinder(d = 15, h = 3);
        }
        
        // Screw holes for attaching to gear
        for (a = [0, 120, 240]) {
            rotate([0, 0, a])
            translate([5, 0, -1])
            cylinder(d = 2.5, h = 5);
        }
    }
}

// ----------------------------------------------------------------------------
// GEAR ASSEMBLY (COMPLETE)
// ----------------------------------------------------------------------------

module gear_assembly() {
    // Housing base
    color(color_mount, 0.5)
    gear_housing_base();
    
    // Stage 1 pinion (on motor shaft)
    translate([0, 0, housing_wall + 1])
    stage1_pinion();
    
    // Compound gear (stage 1 driven + stage 2 driver)
    translate([stage1_center_dist, 0, housing_wall + 1])
    stage1_gear_stage2_pinion();
    
    // Stage 2 output gear
    translate([stage1_center_dist, stage2_center_dist, housing_wall + gear_height + 5])
    stage2_gear();
}

// ----------------------------------------------------------------------------
// GEARBOX LID
// ----------------------------------------------------------------------------

module gearbox_lid() {
    max_x = max(gear1_od/2, stage1_center_dist + gear2_od/2) + housing_padding;
    min_x = -pinion1_od/2 - housing_padding;
    max_y = gear2_od/2 + housing_padding;
    min_y = -max(gear1_od/2, gear2_od/2) - housing_padding;
    
    housing_width = max_x - min_x + housing_wall * 2;
    housing_depth = max_y - min_y + housing_wall * 2;
    lid_height = housing_wall + 2;
    
    offset_x = (max_x + min_x) / 2;
    offset_y = (max_y + min_y) / 2;
    
    difference() {
        union() {
            // Main lid
            translate([offset_x - housing_width/2, offset_y - housing_depth/2, 0])
            rounded_box(housing_width, housing_depth, housing_wall, 5);
            
            // Inner lip for alignment
            translate([offset_x - housing_width/2 + housing_wall + 0.5, 
                       offset_y - housing_depth/2 + housing_wall + 0.5, 
                       housing_wall])
            rounded_box(housing_width - housing_wall*2 - 1, 
                        housing_depth - housing_wall*2 - 1, 
                        2, 2);
        }
        
        // Output shaft bearing seat
        translate([stage1_center_dist, stage2_center_dist, -1])
        cylinder(d = bearing_outer_diameter + press_fit_tolerance, h = lid_height + 2);
        
        // Screw holes for lid attachment
        for (corner = [[offset_x - housing_width/2 + 8, offset_y - housing_depth/2 + 8],
                       [offset_x + housing_width/2 - 8, offset_y - housing_depth/2 + 8],
                       [offset_x - housing_width/2 + 8, offset_y + housing_depth/2 - 8],
                       [offset_x + housing_width/2 - 8, offset_y + housing_depth/2 - 8]]) {
            translate([corner[0], corner[1], -1])
            cylinder(d = 3.2, h = lid_height + 2);
        }
    }
}

// ----------------------------------------------------------------------------
// EXPORT INDIVIDUAL PARTS
// ----------------------------------------------------------------------------

// Uncomment the part you want to export:
// stage1_pinion();
// stage1_gear_stage2_pinion();
// stage2_gear();
// gear_housing_base();
// gearbox_lid();

// Preview complete assembly
gear_assembly();
