// ============================================================================
// Luna's Baby Mobile - Motor Mount Housing (Single Shaft Version)
// ============================================================================
// Redesigned for N20 Single Shaft Worm Gear Motor (B-LA008)
// Includes mounting screw holes and ventilation slots
// ============================================================================

include <config.scad>

// ----------------------------------------------------------------------------
// MOTOR MOUNT MODULE
// ----------------------------------------------------------------------------

module motor_mount() {
    wall = motor_mount_wall;
    base_h = motor_mount_base_height;
    
    // Motor pocket dimensions (with tolerance)
    pocket_d = motor_body_diameter + tolerance * 2;
    pocket_l = motor_body_length + tolerance;
    gearbox_w = motor_gearbox_width + tolerance * 2;
    gearbox_h = motor_gearbox_height + tolerance * 2;
    gearbox_l = motor_gearbox_length + tolerance;
    
    // Overall housing dimensions
    housing_w = max(pocket_d, gearbox_w) + wall * 2;
    housing_d = pocket_l + gearbox_l + wall * 2;
    housing_h = max(pocket_d, gearbox_h) / 2 + wall + base_h;
    
    difference() {
        union() {
            // Main housing body
            hull() {
                // Front (motor body side - NO shaft on this end)
                translate([0, wall, base_h + pocket_d/2 + wall])
                rotate([-90, 0, 0])
                cylinder(d = pocket_d + wall * 2, h = pocket_l);
                
                // Base plate
                translate([-(housing_w/2), 0, 0])
                cube([housing_w, pocket_l + wall, base_h]);
            }
            
            // Gearbox housing extension (shaft exits from this end)
            translate([-(gearbox_w/2 + wall), pocket_l + wall, 0])
            cube([gearbox_w + wall * 2, gearbox_l + wall, gearbox_h/2 + wall + base_h]);
            
            // Mounting tabs with screw holes
            for (x = [-1, 1]) {
                translate([x * (housing_w/2 + 8), housing_d/2 - 5, 0])
                mounting_tab();
            }
            
            // Front mounting tab
            translate([0, -5, 0])
            rotate([0, 0, 180])
            mounting_tab();
        }
        
        // Motor body pocket (cylindrical)
        translate([0, wall, base_h + pocket_d/2 + wall])
        rotate([-90, 0, 0])
        cylinder(d = pocket_d, h = pocket_l + 1);
        
        // Gearbox pocket (rectangular)
        translate([-(gearbox_w/2), pocket_l + wall - 0.5, base_h + wall])
        cube([gearbox_w, gearbox_l + 2, gearbox_h + 1]);
        
        // Single shaft exit hole (only on gearbox end)
        translate([0, pocket_l + gearbox_l + wall - 1, base_h + wall + gearbox_h/2])
        rotate([-90, 0, 0])
        cylinder(d = motor_shaft_diameter + 4, h = wall + 2);
        
        // Wire exit slot (bottom rear)
        translate([0, pocket_l + gearbox_l/2, -1])
        cylinder(d = 5, h = base_h + wall + 2);
        
        // Wire exit slot (side option)
        translate([-(housing_w/2) - 1, pocket_l/2, base_h + pocket_d/4])
        rotate([0, 90, 0])
        cylinder(d = 4, h = wall + 2);
        
        // Ventilation slots on top
        for (i = [0:motor_mount_vent_count - 1]) {
            translate([0, wall + 4 + i * 5, base_h + pocket_d + wall + 1])
            rotate([0, 90, 0])
            cylinder(d = motor_mount_vent_diameter, h = housing_w + 2, center = true);
        }
        
        // Ventilation slots on sides
        for (i = [0:2]) {
            for (x = [-1, 1]) {
                translate([x * (housing_w/2 + 1), wall + 6 + i * 6, base_h + pocket_d/2 + wall])
                rotate([0, 90, 0])
                cylinder(d = motor_mount_vent_diameter, h = wall + 2, center = true);
            }
        }
        
        // Motor mounting screw holes (M2) - if motor has them
        if (motor_mounting_hole_spacing > 0) {
            for (x = [-1, 1]) {
                translate([x * motor_mounting_hole_spacing/2, pocket_l + wall - 1, base_h + wall + gearbox_h/2])
                rotate([-90, 0, 0])
                cylinder(d = motor_mounting_hole_diameter + tolerance, h = gearbox_l + wall + 2);
            }
        }
    }
    
    // Motor retaining clips (snap-fit)
    for (x = [-1, 1]) {
        translate([x * (pocket_d/2 + wall/2 - 0.5), wall + pocket_l/2, base_h])
        motor_clip();
    }
}

// Mounting tab with screw hole
module mounting_tab() {
    tab_w = 16;
    tab_l = 18;
    tab_h = motor_mount_base_height;
    
    difference() {
        // Tab body with rounded end
        hull() {
            translate([0, 0, 0])
            cylinder(d = tab_w, h = tab_h);
            translate([0, tab_l - tab_w/2, 0])
            cylinder(d = tab_w, h = tab_h);
        }
        
        // Screw hole
        translate([0, tab_l - tab_w/2, -1])
        cylinder(d = motor_mount_screw_diameter + tolerance, h = tab_h + 2);
        
        // Countersink
        translate([0, tab_l - tab_w/2, tab_h - 1.5])
        cylinder(d1 = motor_mount_screw_diameter + tolerance, 
                 d2 = motor_mount_screw_diameter + 4, h = 2);
    }
}

// Snap-fit motor retaining clip
module motor_clip() {
    clip_h = motor_body_diameter / 2 + motor_mount_wall;
    clip_w = 4;
    clip_t = 1.5;
    
    // Flexible arm
    translate([-clip_w/2, -2.5, 0])
    cube([clip_w, 5, clip_h - 2]);
    
    // Catch lip
    translate([-clip_w/2, -2.5, clip_h - 2])
    rotate([25, 0, 0])
    cube([clip_w, 3.5, 1.5]);
}

// ----------------------------------------------------------------------------
// MOTOR DUMMY (for visualization) - Single Shaft Version
// ----------------------------------------------------------------------------

module motor_dummy() {
    color(color_motor) {
        // Motor body
        rotate([-90, 0, 0])
        cylinder(d = motor_body_diameter, h = motor_body_length);
        
        // Gearbox
        translate([-(motor_gearbox_width/2), motor_body_length, -(motor_gearbox_height/2)])
        cube([motor_gearbox_width, motor_gearbox_length, motor_gearbox_height]);
        
        // Output shaft (single shaft - only on gearbox end)
        translate([0, motor_total_length, 0])
        rotate([-90, 0, 0]) {
            difference() {
                cylinder(d = motor_shaft_diameter, h = motor_shaft_length);
                // D-flat
                translate([motor_shaft_diameter/2 - motor_shaft_flat_depth, -motor_shaft_diameter/2, -1])
                cube([motor_shaft_diameter, motor_shaft_diameter, motor_shaft_length + 2]);
            }
        }
    }
}

// D-shaft profile (for gear bore)
module d_shaft_profile(d, flat_depth) {
    difference() {
        circle(d = d);
        translate([d/2 - flat_depth, -d/2])
        square([d, d]);
    }
}

// ----------------------------------------------------------------------------
// RENDER
// ----------------------------------------------------------------------------

if ($preview) {
    motor_mount();
    
    // Show motor in position
    translate([0, motor_mount_wall, motor_mount_base_height + motor_body_diameter/2 + motor_mount_wall])
    motor_dummy();
} else {
    motor_mount();
}
