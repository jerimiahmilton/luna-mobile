// ============================================================================
// Luna's Baby Mobile - Complete Assembly
// ============================================================================
// Main assembly file - imports all components and shows the complete mobile
// Use this for visualization and final renders
// ============================================================================

include <config.scad>

// Import all component modules
use <motor_mount.scad>
use <gear_assembly.scad>
use <central_hub.scad>
use <arm.scad>
use <ceiling_mount.scad>
use <crib_clamp.scad>
use <battery_mount.scad>
use <switch_mount.scad>
use <barrel_jack.scad>

// ----------------------------------------------------------------------------
// ASSEMBLY CONFIGURATION
// ----------------------------------------------------------------------------

// Choose which mount to display
mount_type = "ceiling";  // "ceiling" or "crib"

// Show/hide components
show_mount = true;
show_motor = true;
show_gears = true;
show_hub = true;
show_arms = true;
show_mobile_elements = true;
show_electronics = true;     // Battery, switch, barrel jack

// Animation
animate = false;
rotation_speed = target_rpm;  // Uses calculated RPM from config
current_angle = animate ? $t * 360 * rotation_speed : 0;

// Electronics placement
electronics_offset = [80, 0, 0];  // Position relative to main assembly

// ----------------------------------------------------------------------------
// COMPLETE CEILING MOUNT ASSEMBLY
// ----------------------------------------------------------------------------

module ceiling_assembly() {
    // Ceiling mount (fixed)
    if (show_mount) {
        ceiling_mount();
    }
    
    // Motor and gearbox (mounted to ceiling bracket)
    if (show_motor) {
        translate([40, 30, -ceiling_mount_height + ceiling_plate_thickness - 20])
        rotate([180, 0, 0])
        motor_mount();
    }
    
    // Gear assembly (simplified single-stage)
    if (show_gears) {
        translate([0, 0, -ceiling_mount_height + ceiling_plate_thickness - 10])
        rotate([180, 0, 0])
        gear_assembly();
    }
    
    // Electronics (battery, switch, barrel jack)
    if (show_electronics) {
        translate(electronics_offset)
        electronics_assembly();
    }
    
    // Rotating assembly (hub + arms)
    translate([0, 0, -ceiling_mount_height - 10])
    rotate([0, 0, current_angle]) {
        // Central hub
        if (show_hub) {
            central_hub();
        }
        
        // Arms
        if (show_arms) {
            for (i = [0:hub_arm_count-1]) {
                rotate([0, 0, i * (360/hub_arm_count)])
                translate([hub_outer_diameter/2 - 5, 0, hub_height/2])
                rotate([0, 90, 0])
                rotate([0, 0, 90])
                arm();
            }
        }
        
        // Mobile elements (decorative spheres for visualization)
        if (show_mobile_elements) {
            for (i = [0:hub_arm_count-1]) {
                rotate([0, 0, i * (360/hub_arm_count)])
                translate([hub_outer_diameter/2 + arm_length, 0, hub_height/2])
                mobile_element(i);
            }
        }
    }
}

// ----------------------------------------------------------------------------
// COMPLETE CRIB MOUNT ASSEMBLY
// ----------------------------------------------------------------------------

module crib_assembly() {
    // Crib clamp (attached to rail)
    if (show_mount) {
        rotate([90, 0, 0])
        crib_clamp();
    }
    
    // Motor and gearbox (mounted to clamp)
    if (show_motor) {
        translate([crib_rail_thickness/2 + 10 + 30, 0, clamp_jaw_depth + 40])
        motor_mount();
    }
    
    // Electronics (integrated with clamp body)
    if (show_electronics) {
        translate([crib_rail_thickness/2 + 80, 0, clamp_jaw_depth + 20])
        electronics_assembly();
    }
    
    // Rotating assembly
    translate([crib_rail_thickness/2 + 10, 0, clamp_jaw_depth + 30 + 30])
    rotate([0, 0, current_angle]) {
        // Central hub
        if (show_hub) {
            rotate([180, 0, 0])
            central_hub();
        }
        
        // Arms
        if (show_arms) {
            for (i = [0:hub_arm_count-1]) {
                rotate([0, 0, i * (360/hub_arm_count)])
                translate([hub_outer_diameter/2 - 5, 0, -hub_height/2])
                rotate([0, -90, 0])
                rotate([0, 0, -90])
                arm();
            }
        }
        
        // Mobile elements
        if (show_mobile_elements) {
            for (i = [0:hub_arm_count-1]) {
                rotate([0, 0, i * (360/hub_arm_count)])
                translate([hub_outer_diameter/2 + arm_length - 10, 0, -hub_height/2 - 30])
                mobile_element(i);
            }
        }
    }
}

// ----------------------------------------------------------------------------
// ELECTRONICS ASSEMBLY (Battery + Switch + Barrel Jack)
// ----------------------------------------------------------------------------

module electronics_assembly() {
    // Battery mount
    color(color_electronics, 0.8)
    battery_cradle_mount();
    
    // Battery case (dummy)
    translate([0, 0, battery_mount_wall + battery_case_height/2 + battery_mount_clearance])
    battery_case_dummy();
    
    // Power switch mount (positioned at edge of battery mount)
    translate([battery_case_length/2 + 25, 0, 0])
    rotate([0, 0, 90]) {
        color(color_electronics, 0.8)
        switch_panel_mount();
        
        // Switch dummy
        translate([switch_mount_wall + switch_mount_clearance + switch_length/2, 
                   switch_mount_wall + switch_mount_clearance + switch_width/2, 
                   switch_mount_wall + switch_height/2])
        switch_dummy();
    }
    
    // Optional: Barrel jack (for wall power)
    translate([-battery_case_length/2 - 20, 0, 10])
    rotate([0, 0, -90]) {
        color(color_electronics, 0.8)
        barrel_jack_panel_mount();
        
        // Barrel jack model
        translate([barrel_jack_flange_diameter/2 + 5, 3, (barrel_jack_flange_diameter + 10)/2])
        rotate([-90, 0, 0])
        barrel_jack_model();
    }
}

// Forward declaration for battery/switch dummies
module battery_case_dummy() {
    color(color_battery) {
        cube([battery_case_length, battery_case_width, battery_case_height], center = true);
        translate([0, battery_case_width/2 + 5, 0])
        rotate([90, 0, 0])
        cylinder(d = 4, h = 10);
    }
}

module switch_dummy() {
    color(color_switch) {
        cube([switch_length, switch_width, 2], center = true);
        translate([0, 0, 2])
        cube([15, 10, 8], center = true);
        translate([0, 0, 6 + switch_actuator_height/2])
        cube([8, 6, switch_actuator_height], center = true);
        translate([switch_length/2 - 3, 0, -2])
        cube([6, 8, 4], center = true);
    }
}

// ----------------------------------------------------------------------------
// DECORATIVE MOBILE ELEMENTS
// ----------------------------------------------------------------------------

// Sample hanging elements (stars, moons, clouds)
module mobile_element(index) {
    // Different elements based on index
    color_palette = [
        [0.95, 0.85, 0.95],  // Lavender
        [0.85, 0.95, 0.95],  // Mint
        [0.95, 0.95, 0.85],  // Cream
        [0.95, 0.90, 0.95],  // Pink
    ];
    
    col = color_palette[index % 4];
    
    // String/thread
    color([0.8, 0.8, 0.8])
    translate([0, 0, 0])
    cylinder(d = 1, h = 40);
    
    // Element
    translate([0, 0, -40])
    color(col) {
        if (index == 0) {
            // Star
            scale([15, 15, 3])
            star_3d();
        } else if (index == 1) {
            // Moon (🌙 for Luna!)
            scale([1.5, 1.5, 1])
            moon_3d();
        } else if (index == 2) {
            // Cloud
            cloud_3d();
        } else {
            // Heart
            scale([12, 12, 4])
            heart_3d();
        }
    }
}

// 3D Star
module star_3d() {
    linear_extrude(height = 1, scale = 0.5)
    star_2d(5, 1, 0.5);
    
    translate([0, 0, 1])
    mirror([0, 0, 1])
    linear_extrude(height = 1, scale = 0.5)
    star_2d(5, 1, 0.5);
}

module star_2d(points, outer_r, inner_r) {
    polygon([for (i = [0:points*2-1])
        let(r = i % 2 == 0 ? outer_r : inner_r,
            a = i * 180 / points - 90)
        [r * cos(a), r * sin(a)]
    ]);
}

// 3D Moon (crescent) - For Luna! 🌙
module moon_3d() {
    difference() {
        sphere(d = 25);
        translate([8, 0, 0])
        sphere(d = 22);
    }
}

// 3D Cloud
module cloud_3d() {
    hull() {
        sphere(d = 20);
        translate([12, 0, 0]) sphere(d = 16);
        translate([-10, 0, 0]) sphere(d = 14);
        translate([5, 8, 0]) sphere(d = 12);
    }
}

// 3D Heart
module heart_3d() {
    linear_extrude(height = 1, scale = 0.8)
    heart_2d();
}

module heart_2d() {
    union() {
        translate([-0.5, 0, 0]) circle(d = 1);
        translate([0.5, 0, 0]) circle(d = 1);
        rotate([0, 0, 45])
        square([1, 1], center = true);
    }
}

// ----------------------------------------------------------------------------
// EXPLODED VIEW
// ----------------------------------------------------------------------------

module exploded_assembly(explode = 50) {
    // Ceiling mount
    translate([0, 0, explode * 4])
    ceiling_mount();
    
    // Bearing
    translate([0, 0, explode * 3])
    color(color_bearing)
    difference() {
        cylinder(d = bearing_outer_diameter, h = bearing_width);
        translate([0, 0, -1])
        cylinder(d = bearing_inner_diameter, h = bearing_width + 2);
    }
    
    // Gear assembly
    translate([0, 0, explode * 2])
    gear_assembly();
    
    // Motor mount
    translate([40, 30, explode * 1.5])
    motor_mount();
    
    // Hub
    translate([0, 0, 0])
    central_hub();
    
    // Arms
    for (i = [0:hub_arm_count-1]) {
        rotate([0, 0, i * (360/hub_arm_count)])
        translate([hub_outer_diameter/2 + explode/2, 0, hub_height/2])
        rotate([0, 90, 0])
        rotate([0, 0, 90])
        arm();
    }
    
    // Electronics
    translate([explode * 2, 0, -explode])
    electronics_assembly();
}

// ----------------------------------------------------------------------------
// PRINT PLATE LAYOUTS
// ----------------------------------------------------------------------------

// All mechanical parts laid out for printing
module print_plate_mechanical() {
    // Hub
    central_hub();
    
    // Arms (x4)
    translate([80, 0, 0]) arm();
    translate([80, 20, 0]) arm();
    translate([80, 40, 0]) arm();
    translate([80, 60, 0]) arm();
    
    // Ceiling mount
    translate([0, 100, ceiling_mount_height])
    rotate([180, 0, 0])
    ceiling_mount();
    
    // Motor mount
    translate([100, 100, 0])
    motor_mount();
    
    // Gears
    translate([180, 0, 0]) motor_pinion();
    translate([180, 50, 0]) output_gear();
}

// Electronics mounts laid out for printing
module print_plate_electronics() {
    // Battery mount
    battery_cradle_mount();
    
    // Switch mount
    translate([100, 0, 0])
    switch_panel_mount();
    
    // Barrel jack mount
    translate([150, 0, 0])
    barrel_jack_panel_mount();
}

// ----------------------------------------------------------------------------
// WIRING DIAGRAM (2D visualization)
// ----------------------------------------------------------------------------

module wiring_diagram() {
    // This is a simple 2D representation for reference
    // See README.md for detailed wiring instructions
    
    translate([0, 0, 0.1])
    color([0.2, 0.5, 0.8])
    linear_extrude(height = 0.1)
    text("See README.md for wiring diagram", size = 5);
}

// ----------------------------------------------------------------------------
// MAIN RENDER
// ----------------------------------------------------------------------------

if (mount_type == "ceiling") {
    ceiling_assembly();
} else {
    crib_assembly();
}

// Uncomment for other views:
// exploded_assembly(80);
// print_plate_mechanical();
// print_plate_electronics();
