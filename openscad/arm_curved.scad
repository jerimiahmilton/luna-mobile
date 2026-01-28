// ============================================================================
// Luna's Baby Mobile - Curved Arms with Integrated Hooks
// ============================================================================
// Elegant curved arms inspired by Scandinavian design
// Features a sweeping arc shape with integrated downward hooks
// for hanging decorations
// ============================================================================

include <config.scad>

// ----------------------------------------------------------------------------
// CURVED ARM PARAMETERS (can be overridden)
// ----------------------------------------------------------------------------
// These provide defaults if not defined in config.scad

// Arm dimensions
curved_arm_length = is_undef(arm_curved_length) ? 85 : arm_curved_length;
curved_arm_width = is_undef(arm_curved_width) ? 14 : arm_curved_width;
curved_arm_height = is_undef(arm_curved_height) ? 8 : arm_curved_height;

// Curve parameters
curve_arc_height = is_undef(arm_curve_arc_height) ? 12 : arm_curve_arc_height;
curve_segments = is_undef(arm_curve_segments) ? 64 : arm_curve_segments;

// Hook parameters
hook_count = is_undef(arm_hook_count) ? 2 : arm_hook_count;
hook_inner_diameter = is_undef(arm_hook_inner_dia) ? 6 : arm_hook_inner_dia;
hook_wire_thickness = is_undef(arm_hook_wire) ? 3 : arm_hook_wire;
hook_depth = is_undef(arm_hook_depth) ? 12 : arm_hook_depth;
hook_opening_angle = is_undef(arm_hook_opening) ? 45 : arm_hook_opening;

// Mounting parameters  
mount_hole_diameter = is_undef(arm_mount_hole_dia) ? 3.2 : arm_mount_hole_dia; // M3 clearance
mount_hole_spacing = is_undef(arm_mount_spacing) ? 10 : arm_mount_spacing;
mount_tab_length = is_undef(arm_mount_length) ? 18 : arm_mount_length;
mount_tab_width = is_undef(arm_mount_width) ? 20 : arm_mount_width;

// Aesthetic channel parameters
channel_width = is_undef(arm_channel_width) ? 4 : arm_channel_width;
channel_depth = is_undef(arm_channel_depth) ? 1.5 : arm_channel_depth;
channel_count = is_undef(arm_channel_count) ? 2 : arm_channel_count;

// ----------------------------------------------------------------------------
// HELPER FUNCTIONS
// ----------------------------------------------------------------------------

// Compute point on the curved arm centerline
// Uses a parabolic arc for elegant sweep
function arm_curve_point(t) = [
    t * curved_arm_length,
    0,
    curve_arc_height * 4 * t * (1 - t)  // Parabolic arc, peaks at t=0.5
];

// Width taper along arm (wider at mount, narrower at tip)
function arm_width_at(t) = curved_arm_width * (1 - 0.2 * t);

// Height taper along arm
function arm_height_at(t) = curved_arm_height * (1 - 0.15 * t);

// ----------------------------------------------------------------------------
// CURVED ARM BODY
// ----------------------------------------------------------------------------

module curved_arm_body() {
    // Build the curved arm using hull between cross-sections
    steps = curve_segments;
    
    for (i = [0:steps-1]) {
        t1 = i / steps;
        t2 = (i + 1) / steps;
        
        p1 = arm_curve_point(t1);
        p2 = arm_curve_point(t2);
        
        w1 = arm_width_at(t1);
        w2 = arm_width_at(t2);
        h1 = arm_height_at(t1);
        h2 = arm_height_at(t2);
        
        hull() {
            translate(p1)
            arm_cross_section(w1, h1);
            
            translate(p2)
            arm_cross_section(w2, h2);
        }
    }
}

// Rounded rectangular cross-section (stadium/pill shape)
module arm_cross_section(w, h) {
    // Horizontal pill shape - rounded ends
    hull() {
        translate([0, -w/2 + h/2, 0])
        sphere(d = h, $fn = 16);
        translate([0, w/2 - h/2, 0])
        sphere(d = h, $fn = 16);
    }
}

// Alternative: More rectangular with rounded edges
module arm_cross_section_rect(w, h) {
    r = min(w, h) * 0.25;  // Corner radius
    
    hull() {
        for (y = [-w/2 + r, w/2 - r])
            for (z = [-h/2 + r, h/2 + r])
                translate([0, y, z])
                sphere(r = r, $fn = 12);
    }
}

// ----------------------------------------------------------------------------
// MOUNTING TAB
// ----------------------------------------------------------------------------

module mounting_tab() {
    difference() {
        // Tab body - extends from arm base
        hull() {
            // Connection to arm
            translate([0, 0, 0])
            arm_cross_section(curved_arm_width, curved_arm_height);
            
            // Tab end (flat for mounting)
            translate([-mount_tab_length + 5, 0, -curved_arm_height/2])
            linear_extrude(height = curved_arm_height)
            offset(r = 3)
            square([mount_tab_length - 10, mount_tab_width - 6], center = true);
        }
        
        // Mounting holes
        translate([-mount_tab_length/2, mount_hole_spacing/2, 0])
        cylinder(d = mount_hole_diameter, h = curved_arm_height + 10, center = true, $fn = 24);
        
        translate([-mount_tab_length/2, -mount_hole_spacing/2, 0])
        cylinder(d = mount_hole_diameter, h = curved_arm_height + 10, center = true, $fn = 24);
        
        // Countersink (optional, for flush screw heads)
        translate([-mount_tab_length/2, mount_hole_spacing/2, curved_arm_height/2 - 1.5])
        cylinder(d1 = mount_hole_diameter, d2 = mount_hole_diameter * 2, h = 2, $fn = 24);
        
        translate([-mount_tab_length/2, -mount_hole_spacing/2, curved_arm_height/2 - 1.5])
        cylinder(d1 = mount_hole_diameter, d2 = mount_hole_diameter * 2, h = 2, $fn = 24);
    }
}

// ----------------------------------------------------------------------------
// INTEGRATED HOOKS
// ----------------------------------------------------------------------------

module hook_integrated(flip = false) {
    // Elegant C-shaped hook that opens outward for easy string attachment
    // Integrated smoothly into the arm body
    
    r_inner = hook_inner_diameter / 2;
    r_wire = hook_wire_thickness / 2;
    
    mirror([0, flip ? 1 : 0, 0])
    rotate([0, 0, 0]) {
        // Hook stem (connects to arm)
        translate([0, 0, -hook_depth/3])
        cylinder(r = r_wire, h = hook_depth/3 + 0.1, $fn = 24);
        
        // C-curve of hook
        translate([0, 0, -hook_depth])
        rotate([0, 90, -90 + hook_opening_angle/2])
        rotate_extrude(angle = 270 - hook_opening_angle, convexity = 4, $fn = 48)
        translate([r_inner + r_wire, 0, 0])
        circle(r = r_wire, $fn = 16);
        
        // Decorative ball at hook tip (prevents string from slipping)
        hook_end_angle = 270 - hook_opening_angle;
        tip_x = (r_inner + r_wire) * cos(-90 + hook_opening_angle/2 + hook_end_angle);
        tip_y = (r_inner + r_wire) * sin(-90 + hook_opening_angle/2 + hook_end_angle);
        
        translate([tip_x, tip_y, -hook_depth])
        sphere(r = r_wire * 1.3, $fn = 16);
        
        // Small ball at opening tip too
        opening_x = (r_inner + r_wire) * cos(-90 + hook_opening_angle/2);
        opening_y = (r_inner + r_wire) * sin(-90 + hook_opening_angle/2);
        
        translate([opening_x, opening_y, -hook_depth])
        sphere(r = r_wire * 1.2, $fn = 16);
    }
}

// Simpler teardrop hook for easier printing
module hook_teardrop() {
    r_wire = hook_wire_thickness / 2;
    
    // Vertical stem
    cylinder(r = r_wire, h = hook_depth/2, $fn = 24);
    
    // Teardrop loop
    translate([0, 0, -hook_depth])
    rotate([90, 0, 0])
    linear_extrude(height = r_wire * 2, center = true)
    teardrop_2d(hook_inner_diameter/2 + r_wire);
}

module teardrop_2d(r) {
    union() {
        circle(r = r, $fn = 32);
        rotate([0, 0, 45])
        square([r, r]);
    }
}

// ----------------------------------------------------------------------------
// AESTHETIC CHANNELS
// ----------------------------------------------------------------------------

module top_channels() {
    // Decorative recessed channels along the top surface
    // Following the curve of the arm
    
    for (c = [0:channel_count-1]) {
        channel_offset = (c - (channel_count-1)/2) * (channel_width + 2);
        
        // Create channel following arm curve
        hull_chain_channel(channel_offset);
    }
}

module hull_chain_channel(y_offset) {
    steps = curve_segments / 2;  // Fewer steps for channels
    
    for (i = [1:steps-2]) {  // Skip first and last segments
        t1 = i / steps;
        t2 = (i + 1) / steps;
        
        p1 = arm_curve_point(t1);
        p2 = arm_curve_point(t2);
        
        hull() {
            translate(p1 + [0, y_offset, arm_height_at(t1)/2 - channel_depth/2])
            sphere(d = channel_width, $fn = 12);
            
            translate(p2 + [0, y_offset, arm_height_at(t2)/2 - channel_depth/2])
            sphere(d = channel_width, $fn = 12);
        }
    }
}

// Simpler channel - single groove down center
module center_channel() {
    steps = curve_segments / 2;
    
    for (i = [2:steps-3]) {
        t1 = i / steps;
        t2 = (i + 1) / steps;
        
        p1 = arm_curve_point(t1);
        p2 = arm_curve_point(t2);
        
        hull() {
            translate(p1 + [0, 0, arm_height_at(t1)/2 - channel_depth + 0.5])
            scale([1, channel_width/channel_depth, 1])
            sphere(d = channel_depth * 2, $fn = 12);
            
            translate(p2 + [0, 0, arm_height_at(t2)/2 - channel_depth + 0.5])
            scale([1, channel_width/channel_depth, 1])
            sphere(d = channel_depth * 2, $fn = 12);
        }
    }
}

// ----------------------------------------------------------------------------
// COMPLETE CURVED ARM
// ----------------------------------------------------------------------------

module arm_curved() {
    color(color_arms)
    difference() {
        union() {
            // Main curved body
            curved_arm_body();
            
            // Mounting tab at base
            mounting_tab();
            
            // Integrated hooks
            // Position hooks along the arm
            for (h = [0:hook_count-1]) {
                // Distribute hooks evenly, avoiding the very ends
                t = 0.35 + h * 0.4 / max(1, hook_count - 1);
                
                p = arm_curve_point(t);
                
                translate(p + [0, 0, -arm_height_at(t)/2])
                hook_integrated(h % 2 == 1);  // Alternate hook direction
            }
        }
        
        // Subtract aesthetic channels
        center_channel();
    }
}

// ----------------------------------------------------------------------------
// ALTERNATIVE STYLES
// ----------------------------------------------------------------------------

// More dramatic S-curve
module arm_curved_s() {
    // S-curve variation - TODO: implement
    arm_curved();
}

// Minimal - no channels
module arm_curved_minimal() {
    color(color_arms)
    union() {
        curved_arm_body();
        mounting_tab();
        
        for (h = [0:hook_count-1]) {
            t = 0.35 + h * 0.4 / max(1, hook_count - 1);
            p = arm_curve_point(t);
            
            translate(p + [0, 0, -arm_height_at(t)/2])
            hook_integrated(h % 2 == 1);
        }
    }
}

// ----------------------------------------------------------------------------
// ARM SET (ALL 4 FOR PRINT PLATE)
// ----------------------------------------------------------------------------

module arm_curved_set() {
    // Four arms arranged for printing
    spacing = curved_arm_width + 10;
    
    for (i = [0:3]) {
        translate([0, i * spacing, 0])
        arm_curved();
    }
}

// ----------------------------------------------------------------------------
// RENDER
// ----------------------------------------------------------------------------

if ($preview) {
    // Preview: show single arm with mounting orientation
    arm_curved();
    
    // Show a second one rotated to visualize how they'd look on hub
    %translate([0, curved_arm_width * 2, 0])
    mirror([1, 0, 0])
    arm_curved();
} else {
    // Export: all four arms for printing
    arm_curved_set();
}
