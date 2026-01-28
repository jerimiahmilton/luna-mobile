// ============================================================================
// Luna's Baby Mobile - Arms
// ============================================================================
// Graceful arms that extend from the central hub
// Features hooks at the end for hanging mobile elements
// ============================================================================

include <config.scad>

// ----------------------------------------------------------------------------
// ARM MODULE
// ----------------------------------------------------------------------------
// Elegant arm with attachment plug and decorative hook

module arm() {
    color(color_arms)
    union() {
        // Attachment plug (goes into hub socket)
        arm_plug();
        
        // Main arm body
        translate([arm_plug_length, 0, 0])
        arm_body();
        
        // Hook at the end
        translate([arm_plug_length + arm_length, 0, 0])
        arm_hook();
    }
}

// Plug that inserts into hub
module arm_plug() {
    // Tapered plug for easy insertion
    hull() {
        cylinder(d = arm_plug_diameter, h = arm_thickness, center = true);
        translate([arm_plug_length - 2, 0, 0])
        cylinder(d = arm_plug_diameter, h = arm_thickness, center = true);
    }
    
    // Slight ridge for snap fit
    translate([arm_plug_length/2, 0, 0])
    cylinder(d = arm_plug_diameter + 0.5, h = arm_thickness - 1, center = true);
}

// Main arm body - elegant tapered design
module arm_body() {
    // Tapered arm (wider at hub, narrower at end)
    hull() {
        // At hub end
        translate([0, 0, 0])
        scale([1, 1, arm_thickness/arm_width])
        rotate([0, 90, 0])
        cylinder(d = arm_width, h = 1);
        
        // At hook end (narrower)
        translate([arm_length - 1, 0, 0])
        scale([1, 1, arm_thickness/arm_width])
        rotate([0, 90, 0])
        cylinder(d = arm_width * 0.7, h = 1);
    }
}

// Hook for hanging mobile elements
module arm_hook() {
    hook_r = arm_hook_diameter / 2;
    hook_t = arm_hook_thickness;
    
    // Graceful curved hook
    rotate([0, 0, 90])
    rotate_extrude(angle = 270, convexity = 10)
    translate([hook_r + hook_t/2, 0, 0])
    circle(d = hook_t);
    
    // Connection to arm
    translate([0, -hook_r - hook_t/2, 0])
    rotate([0, 90, 0])
    cylinder(d = hook_t, h = 5);
    
    // Decorative ball at hook end
    translate([0, hook_r + hook_t/2, 0])
    sphere(d = hook_t * 1.5);
}

// ----------------------------------------------------------------------------
// ALTERNATIVE HOOK STYLES
// ----------------------------------------------------------------------------

// Simple loop hook
module arm_hook_loop() {
    difference() {
        hull() {
            translate([0, 0, 0])
            cylinder(d = arm_hook_diameter + arm_hook_thickness * 2, h = arm_hook_thickness);
            translate([-5, 0, 0])
            cylinder(d = arm_hook_thickness * 2, h = arm_hook_thickness);
        }
        translate([0, 0, -1])
        cylinder(d = arm_hook_diameter, h = arm_hook_thickness + 2);
    }
}

// Star hook (decorative)
module arm_hook_star() {
    points = 5;
    outer_r = arm_hook_diameter;
    inner_r = arm_hook_diameter * 0.5;
    
    linear_extrude(height = arm_hook_thickness, center = true)
    polygon([for (i = [0:points*2-1])
        let(r = i % 2 == 0 ? outer_r : inner_r,
            a = i * 180 / points)
        [r * cos(a), r * sin(a)]
    ]);
}

// Moon hook (for Luna! 🌙)
module arm_hook_moon() {
    hook_r = arm_hook_diameter;
    
    difference() {
        // Full circle
        cylinder(d = hook_r * 2, h = arm_hook_thickness, center = true);
        
        // Crescent cutout
        translate([hook_r * 0.4, 0, 0])
        cylinder(d = hook_r * 1.6, h = arm_hook_thickness + 2, center = true);
        
        // Hanging hole
        translate([-hook_r * 0.5, 0, 0])
        cylinder(d = 4, h = arm_hook_thickness + 2, center = true);
    }
}

// ----------------------------------------------------------------------------
// ARM WITH CUSTOM HOOK
// ----------------------------------------------------------------------------

module arm_custom(hook_style = "default") {
    color(color_arms)
    union() {
        // Attachment plug
        arm_plug();
        
        // Main arm body
        translate([arm_plug_length, 0, 0])
        arm_body();
        
        // Hook based on style
        translate([arm_plug_length + arm_length, 0, 0]) {
            if (hook_style == "loop") {
                arm_hook_loop();
            } else if (hook_style == "star") {
                arm_hook_star();
            } else if (hook_style == "moon") {
                arm_hook_moon();
            } else {
                arm_hook();
            }
        }
    }
}

// ----------------------------------------------------------------------------
// ARM SET (ALL 4)
// ----------------------------------------------------------------------------

module arm_set() {
    // Four arms with different hook styles
    arm_custom("default");
    translate([0, arm_width + 10, 0]) arm_custom("loop");
    translate([0, (arm_width + 10) * 2, 0]) arm_custom("star");
    translate([0, (arm_width + 10) * 3, 0]) arm_custom("moon");
}

// ----------------------------------------------------------------------------
// RENDER
// ----------------------------------------------------------------------------

// Preview single arm
if ($preview) {
    arm();
} else {
    // Export - plate all 4 arms for printing
    arm_set();
}
