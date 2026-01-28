// ============================================================================
// Luna's Baby Mobile - Central Hub
// ============================================================================
// The heart of the mobile - seats the 608 bearing and holds 4 arms
// Clean, minimal aesthetic with soft curves
// ============================================================================

include <config.scad>

// ----------------------------------------------------------------------------
// CENTRAL HUB MODULE
// ----------------------------------------------------------------------------

module central_hub() {
    color(color_hub)
    difference() {
        union() {
            // Main hub body - elegant dome shape
            hull() {
                // Top dome
                translate([0, 0, hub_height - 8])
                sphere(d = hub_outer_diameter * 0.7);
                
                // Middle body
                translate([0, 0, hub_height/2])
                cylinder(d = hub_outer_diameter, h = 0.1);
                
                // Base ring
                cylinder(d = hub_outer_diameter - 5, h = 5);
            }
            
            // Arm sockets
            for (i = [0:hub_arm_count-1]) {
                rotate([0, 0, i * (360/hub_arm_count)])
                translate([hub_outer_diameter/2 - 5, 0, hub_height/2])
                arm_socket();
            }
            
            // Decorative ring at middle
            translate([0, 0, hub_height/2 - 2])
            difference() {
                cylinder(d = hub_outer_diameter + 4, h = 4);
                translate([0, 0, -1])
                cylinder(d = hub_outer_diameter - 2, h = 6);
            }
        }
        
        // Bearing seat (press fit from bottom)
        translate([0, 0, -1])
        cylinder(d = bearing_outer_diameter + press_fit_tolerance, h = bearing_width + 1);
        
        // Shaft through-hole (for driven connection from gearbox)
        translate([0, 0, -1])
        cylinder(d = bearing_inner_diameter + tolerance, h = hub_height + 2);
        
        // Internal cavity (weight reduction)
        translate([0, 0, bearing_width + 3])
        cylinder(d = hub_outer_diameter - hub_wall_thickness * 2 - 10, h = hub_height);
        
        // Arm socket holes (for plugs)
        for (i = [0:hub_arm_count-1]) {
            rotate([0, 0, i * (360/hub_arm_count)])
            translate([hub_outer_diameter/2 - 5, 0, hub_height/2])
            rotate([0, 90, 0])
            cylinder(d = hub_arm_socket_diameter + tolerance, h = hub_arm_socket_depth + 1);
        }
    }
}

// Arm socket boss
module arm_socket() {
    rotate([0, 90, 0])
    hull() {
        cylinder(d = hub_arm_socket_diameter + 6, h = 8);
        translate([0, 0, -5])
        cylinder(d = hub_arm_socket_diameter + 10, h = 1);
    }
}

// ----------------------------------------------------------------------------
// SHAFT ADAPTER
// ----------------------------------------------------------------------------
// Connects the hub to the driven gear shaft
// Press fits into bearing inner race

module hub_shaft_adapter() {
    color(color_mount)
    difference() {
        union() {
            // Main shaft (fits bearing inner diameter)
            cylinder(d = bearing_inner_diameter - press_fit_tolerance, h = bearing_width + 5);
            
            // Flange that rests on bearing
            translate([0, 0, bearing_width])
            cylinder(d = bearing_inner_diameter + 4, h = 3);
            
            // Top attachment (goes into hub)
            translate([0, 0, bearing_width + 3])
            cylinder(d = bearing_inner_diameter - 1, h = 10);
        }
        
        // Screw hole for attachment to gear
        translate([0, 0, -1])
        cylinder(d = 4, h = bearing_width + 20);
    }
}

// ----------------------------------------------------------------------------
// BEARING DUMMY (for visualization)
// ----------------------------------------------------------------------------

module bearing_dummy() {
    color(color_bearing)
    difference() {
        cylinder(d = bearing_outer_diameter, h = bearing_width);
        translate([0, 0, -1])
        cylinder(d = bearing_inner_diameter, h = bearing_width + 2);
    }
}

// ----------------------------------------------------------------------------
// HUB ASSEMBLY PREVIEW
// ----------------------------------------------------------------------------

module hub_assembly() {
    // Central hub
    central_hub();
    
    // Bearing
    translate([0, 0, 0])
    bearing_dummy();
    
    // Shaft adapter
    translate([0, 0, 0])
    hub_shaft_adapter();
}

// ----------------------------------------------------------------------------
// RENDER
// ----------------------------------------------------------------------------

if ($preview) {
    hub_assembly();
} else {
    central_hub();
}
