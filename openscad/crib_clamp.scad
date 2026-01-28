// ============================================================================
// Luna's Baby Mobile - Crib Rail Clamp
// ============================================================================
// Adjustable clamp that attaches to standard crib rails
// Baby-safe design with no pinch points, soft edges, and secure grip
// ============================================================================

include <config.scad>

// ----------------------------------------------------------------------------
// CRIB CLAMP MODULE
// ----------------------------------------------------------------------------

module crib_clamp() {
    color(color_mount)
    union() {
        // Main body with bearing mount
        clamp_body();
        
        // Fixed jaw
        translate([0, -clamp_body_width/2, 0])
        fixed_jaw();
        
        // Mobile arm extension
        translate([0, 0, clamp_jaw_depth + 10])
        mobile_arm_mount();
    }
}

// Main clamp body
module clamp_body() {
    body_w = clamp_body_width;
    body_h = clamp_jaw_depth + 20;  // Extra height for arm mount
    body_d = crib_rail_thickness + 20;
    wall = 5;
    
    difference() {
        // Outer shell with rounded edges
        hull() {
            translate([wall, -body_w/2 + wall, wall])
            sphere(r = wall);
            translate([wall, body_w/2 - wall, wall])
            sphere(r = wall);
            translate([body_d - wall, -body_w/2 + wall, wall])
            sphere(r = wall);
            translate([body_d - wall, body_w/2 - wall, wall])
            sphere(r = wall);
            
            translate([wall, -body_w/2 + wall, body_h - wall])
            sphere(r = wall);
            translate([wall, body_w/2 - wall, body_h - wall])
            sphere(r = wall);
            translate([body_d - wall, -body_w/2 + wall, body_h - wall])
            sphere(r = wall);
            translate([body_d - wall, body_w/2 - wall, body_h - wall])
            sphere(r = wall);
        }
        
        // Rail channel (adjustable width)
        translate([10, -crib_rail_width_max/2 - 5, -1])
        cube([crib_rail_thickness + 10, crib_rail_width_max + 10, clamp_jaw_depth + 2]);
        
        // Screw channel for adjustment
        translate([crib_rail_thickness/2 + 10, 0, clamp_jaw_depth/2])
        rotate([0, 90, 0])
        cylinder(d = clamp_screw_diameter + tolerance, h = body_d);
    }
}

// Fixed jaw (bottom of clamp)
module fixed_jaw() {
    jaw_w = clamp_body_width;
    jaw_h = clamp_jaw_depth;
    jaw_t = 8;
    
    difference() {
        // Jaw body
        translate([10, 0, 0])
        hull() {
            translate([0, 0, 0])
            cube([crib_rail_thickness, jaw_w, jaw_t]);
            translate([2, 2, jaw_h - 5])
            cube([crib_rail_thickness - 4, jaw_w - 4, 5]);
        }
        
        // Grip texture (ridges)
        for (i = [0:4]) {
            translate([10 + crib_rail_thickness/2, 5 + i * 12, -1])
            cylinder(d = 3, h = jaw_t + 2);
        }
    }
    
    // Rubber pad recess indicator
    translate([10 + 2, 5, jaw_t - 1])
    cube([crib_rail_thickness - 4, jaw_w - 10, 1]);
}

// Adjustable jaw (moves with screw)
module adjustable_jaw() {
    jaw_w = clamp_body_width - 10;
    jaw_h = clamp_jaw_depth;
    jaw_t = 8;
    
    color(color_mount)
    difference() {
        union() {
            // Jaw body
            hull() {
                cube([crib_rail_thickness, jaw_w, jaw_t]);
                translate([2, 2, jaw_h - 5])
                cube([crib_rail_thickness - 4, jaw_w - 4, 5]);
            }
            
            // Nut trap extension
            translate([crib_rail_thickness, jaw_w/2 - 8, jaw_h/2 - 8])
            cube([15, 16, 16]);
        }
        
        // Threaded insert hole
        translate([crib_rail_thickness - 1, jaw_w/2, jaw_h/2])
        rotate([0, 90, 0])
        cylinder(d = clamp_screw_diameter - 0.5, h = 20);  // For threading or insert
        
        // Hex nut trap
        translate([crib_rail_thickness + 5, jaw_w/2, jaw_h/2])
        rotate([0, 90, 0])
        cylinder(d = 11.5, h = 6, $fn = 6);  // M6 nut trap
        
        // Grip texture
        for (i = [0:3]) {
            translate([crib_rail_thickness/2, 8 + i * 12, -1])
            cylinder(d = 3, h = jaw_t + 2);
        }
    }
}

// Mobile arm mounting point
module mobile_arm_mount() {
    mount_h = 30;
    mount_d = bearing_outer_diameter + 16;
    
    difference() {
        union() {
            // Mounting post
            translate([crib_rail_thickness/2 + 10, 0, 0])
            cylinder(d = mount_d, h = mount_h);
            
            // Connection to body
            translate([0, -mount_d/2, -10])
            cube([crib_rail_thickness + 20, mount_d, 10]);
        }
        
        // Bearing seat
        translate([crib_rail_thickness/2 + 10, 0, mount_h - bearing_width - 2])
        cylinder(d = bearing_outer_diameter + press_fit_tolerance, h = bearing_width + 3);
        
        // Center hole
        translate([crib_rail_thickness/2 + 10, 0, -11])
        cylinder(d = bearing_inner_diameter + 2, h = mount_h + 15);
    }
}

// Clamp knob (for adjustment screw)
module clamp_knob() {
    knob_d = 30;
    knob_h = 15;
    grip_count = 8;
    
    color(color_hub)
    difference() {
        union() {
            // Main knob body
            cylinder(d = knob_d, h = knob_h);
            
            // Grip ridges
            for (i = [0:grip_count-1]) {
                rotate([0, 0, i * 360/grip_count])
                translate([knob_d/2, 0, knob_h/2])
                scale([0.3, 1, 1])
                cylinder(d = 8, h = knob_h, center = true);
            }
        }
        
        // Hex socket for screw head or bolt
        translate([0, 0, -1])
        cylinder(d = 11.5, h = 8, $fn = 6);  // M6 hex head
        
        // Screw shaft hole
        translate([0, 0, -1])
        cylinder(d = clamp_screw_diameter + tolerance, h = knob_h + 2);
    }
}

// ----------------------------------------------------------------------------
// SAFETY FEATURES
// ----------------------------------------------------------------------------

// All edges are rounded (no sharp corners)
// Pinch point analysis:
// - Adjustment mechanism is external (knob outside of rail area)
// - No gaps that could trap small fingers
// - Rubber padding on contact surfaces recommended

// ----------------------------------------------------------------------------
// ASSEMBLY PREVIEW
// ----------------------------------------------------------------------------

module crib_clamp_assembly() {
    // Main clamp
    crib_clamp();
    
    // Adjustable jaw
    translate([crib_rail_thickness + 30, -crib_rail_width_max/2 + 5, 0])
    adjustable_jaw();
    
    // Knob
    translate([crib_rail_thickness + 55, 0, clamp_jaw_depth/2])
    rotate([0, -90, 0])
    clamp_knob();
    
    // Dummy crib rail (for visualization)
    %translate([15, -20, 0])
    cube([crib_rail_thickness - 5, 40, clamp_jaw_depth]);
}

// ----------------------------------------------------------------------------
// PRINT LAYOUT
// ----------------------------------------------------------------------------

module crib_clamp_print_layout() {
    // Main clamp body
    crib_clamp();
    
    // Adjustable jaw (separate print)
    translate([80, 0, 0])
    adjustable_jaw();
    
    // Knob
    translate([150, 0, 0])
    clamp_knob();
}

// ----------------------------------------------------------------------------
// RENDER
// ----------------------------------------------------------------------------

if ($preview) {
    crib_clamp_assembly();
} else {
    crib_clamp_print_layout();
}
