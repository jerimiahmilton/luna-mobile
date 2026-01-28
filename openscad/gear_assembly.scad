// ============================================================================
// Luna's Baby Mobile - Simplified Gear Reduction Assembly
// ============================================================================
// Single-stage gear reduction: 30 RPM → ~3.75 RPM
// Total reduction ratio: 8:1 (12T pinion : 96T gear)
// Much simpler than the previous two-stage design!
// ============================================================================

include <config.scad>
include <gears.scad>

// ----------------------------------------------------------------------------
// GEAR CALCULATIONS
// ----------------------------------------------------------------------------
// With 30 RPM motor, single stage is sufficient:
// 30 RPM ÷ 8 = 3.75 RPM (perfect for gentle mobile rotation)

center_dist = center_distance(pinion_teeth, gear_teeth, gear_module);
pinion_od = outer_diameter(pinion_teeth, gear_module);
gear_od = outer_diameter(gear_teeth, gear_module);

// Housing dimensions
housing_wall = 3;
housing_padding = 5;

// Echo calculated values for verification
echo("=== GEAR ASSEMBLY CALCULATIONS ===");
echo(str("Pinion teeth: ", pinion_teeth));
echo(str("Gear teeth: ", gear_teeth));
echo(str("Gear ratio: ", gear_ratio, ":1"));
echo(str("Center distance: ", center_dist, " mm"));
echo(str("Pinion OD: ", pinion_od, " mm"));
echo(str("Gear OD: ", gear_od, " mm"));
echo(str("Input RPM: ", motor_rpm));
echo(str("Output RPM: ", target_rpm));

// ----------------------------------------------------------------------------
// GEAR HOUSING (SIMPLIFIED)
// ----------------------------------------------------------------------------

module gear_housing() {
    // Calculate housing dimensions
    housing_width = gear_od + housing_padding * 2 + housing_wall * 2;
    housing_depth = center_dist + pinion_od/2 + gear_od/2 + housing_padding * 2 + housing_wall * 2;
    housing_height = gear_height + bearing_width + 8;  // Space for gear + bearing + clearance
    
    // Offset for centering
    offset_y = center_dist / 2;
    
    difference() {
        union() {
            // Main housing body
            translate([-housing_width/2, -pinion_od/2 - housing_padding - housing_wall, 0])
            rounded_box(housing_width, housing_depth, housing_height, 5);
            
            // Motor mount flange
            translate([0, 0, 0])
            cylinder(d = motor_body_diameter + housing_wall * 4, h = housing_wall);
        }
        
        // Interior cavity
        translate([-(housing_width - housing_wall*2)/2, 
                   -pinion_od/2 - housing_padding, 
                   housing_wall])
        rounded_box(housing_width - housing_wall*2, 
                    housing_depth - housing_wall*2, 
                    housing_height, 3);
        
        // Motor shaft entry hole
        translate([0, 0, -1])
        cylinder(d = motor_shaft_diameter + 3, h = housing_wall + 2);
        
        // Output shaft bearing seat (on top)
        translate([0, center_dist, housing_height - bearing_width])
        cylinder(d = bearing_outer_diameter + press_fit_tolerance, h = bearing_width + 2);
        
        // Lid screw holes
        for (pos = get_lid_screw_positions()) {
            translate([pos[0], pos[1], -1])
            cylinder(d = 2.5, h = housing_height + 2);
        }
    }
    
    // Internal bearing post for output gear
    translate([0, center_dist, housing_wall])
    difference() {
        cylinder(d = bearing_outer_diameter + 6, h = gear_height + 2);
        translate([0, 0, -1])
        cylinder(d = bearing_inner_diameter + tolerance, h = gear_height + 4);
    }
}

// Get positions for lid screws
function get_lid_screw_positions() = [
    [-gear_od/2 - 3, -pinion_od/2 - 3],
    [gear_od/2 + 3, -pinion_od/2 - 3],
    [-gear_od/2 - 3, center_dist + gear_od/2 + 3],
    [gear_od/2 + 3, center_dist + gear_od/2 + 3]
];

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
// GEARBOX LID
// ----------------------------------------------------------------------------

module gearbox_lid() {
    housing_width = gear_od + housing_padding * 2 + housing_wall * 2;
    housing_depth = center_dist + pinion_od/2 + gear_od/2 + housing_padding * 2 + housing_wall * 2;
    lid_height = housing_wall;
    
    difference() {
        union() {
            // Main lid plate
            translate([-housing_width/2, -pinion_od/2 - housing_padding - housing_wall, 0])
            rounded_box(housing_width, housing_depth, lid_height, 5);
            
            // Alignment lip (fits inside housing)
            translate([-(housing_width - housing_wall*2 - 1)/2, 
                       -pinion_od/2 - housing_padding + 0.5, 
                       lid_height])
            rounded_box(housing_width - housing_wall*2 - 1, 
                        housing_depth - housing_wall*2 - 1, 
                        2, 2);
        }
        
        // Output shaft hole (bearing sits here)
        translate([0, center_dist, -1])
        cylinder(d = bearing_outer_diameter + press_fit_tolerance, h = lid_height + 4);
        
        // Screw holes for lid
        for (pos = get_lid_screw_positions()) {
            translate([pos[0], pos[1], -1])
            cylinder(d = 3.2, h = lid_height + 5);
            
            // Countersink
            translate([pos[0], pos[1], lid_height - 1.5])
            cylinder(d1 = 3.2, d2 = 6, h = 2);
        }
    }
}

// ----------------------------------------------------------------------------
// MOTOR PINION (12 tooth)
// ----------------------------------------------------------------------------

module motor_pinion() {
    color(color_gears)
    difference() {
        union() {
            // Main gear
            involute_gear(
                teeth = pinion_teeth,
                mod = gear_module,
                thickness = gear_height,
                bore = 0,
                pressure_angle = gear_pressure_angle,
                backlash = gear_backlash,
                hub_diameter = 10,
                hub_height = 3
            );
        }
        
        // D-shaft bore for motor shaft
        translate([0, 0, -1])
        linear_extrude(height = gear_height + 5)
        d_shaft_bore(motor_shaft_diameter + press_fit_tolerance, motor_shaft_flat_depth);
        
        // Set screw hole (M2)
        translate([0, motor_shaft_diameter/2 + 1, gear_height/2])
        rotate([90, 0, 0])
        cylinder(d = 2, h = 6);
    }
}

// D-shaft bore profile
module d_shaft_bore(d, flat_depth) {
    difference() {
        circle(d = d);
        translate([d/2 - flat_depth, -d])
        square([d, d * 2]);
    }
}

// ----------------------------------------------------------------------------
// OUTPUT GEAR (96 tooth)
// ----------------------------------------------------------------------------

module output_gear() {
    color(color_gears)
    difference() {
        union() {
            // Main gear
            involute_gear(
                teeth = gear_teeth,
                mod = gear_module,
                thickness = gear_height,
                bore = 0,
                pressure_angle = gear_pressure_angle,
                backlash = gear_backlash,
                hub_diameter = bearing_outer_diameter + 10,
                hub_height = 5
            );
        }
        
        // Central bore for output shaft/bearing
        translate([0, 0, -1])
        cylinder(d = bearing_inner_diameter + press_fit_tolerance, h = gear_height + 7);
        
        // Lightening holes (reduce print time and material)
        spoke_count = 6;
        for (i = [0:spoke_count-1]) {
            rotate([0, 0, i * 360/spoke_count])
            translate([gear_od/2 - 20, 0, -1])
            cylinder(d = 15, h = gear_height + 2);
        }
    }
}

// ----------------------------------------------------------------------------
// OUTPUT SHAFT ADAPTER
// ----------------------------------------------------------------------------
// Connects the output gear to the central hub
// Press-fits into gear bore and hub bearing

module output_shaft() {
    shaft_length = 30;
    flange_d = 15;
    flange_h = 3;
    
    color(color_gears)
    difference() {
        union() {
            // Main shaft (fits into bearing)
            cylinder(d = bearing_inner_diameter - press_fit_tolerance, h = shaft_length);
            
            // Flange for gear attachment
            cylinder(d = flange_d, h = flange_h);
        }
        
        // Hollow center to save material
        translate([0, 0, flange_h])
        cylinder(d = 4, h = shaft_length);
        
        // Attachment screw holes
        for (a = [0, 120, 240]) {
            rotate([0, 0, a])
            translate([5.5, 0, -1])
            cylinder(d = 2.5, h = flange_h + 2);
        }
    }
}

// ----------------------------------------------------------------------------
// COMPLETE GEAR ASSEMBLY
// ----------------------------------------------------------------------------

module gear_assembly() {
    housing_height = gear_height + bearing_width + 8;
    
    // Housing
    color(color_mount, 0.6)
    gear_housing();
    
    // Motor pinion
    translate([0, 0, housing_wall + 1])
    motor_pinion();
    
    // Output gear
    translate([0, center_dist, housing_wall + 1])
    output_gear();
    
    // Output shaft (extending up through bearing)
    translate([0, center_dist, housing_wall + gear_height - 2])
    output_shaft();
    
    // Bearing visualization
    color(color_bearing, 0.7)
    translate([0, center_dist, housing_height - bearing_width])
    difference() {
        cylinder(d = bearing_outer_diameter, h = bearing_width);
        translate([0, 0, -1])
        cylinder(d = bearing_inner_diameter, h = bearing_width + 2);
    }
}

// ----------------------------------------------------------------------------
// EXPORT INDIVIDUAL PARTS
// ----------------------------------------------------------------------------

// Uncomment the part you want to export for printing:
// motor_pinion();
// output_gear();
// output_shaft();
// gear_housing();
// gearbox_lid();

// Preview complete assembly
gear_assembly();

// Show lid separately (positioned above)
// translate([0, 0, 50])
// gearbox_lid();
