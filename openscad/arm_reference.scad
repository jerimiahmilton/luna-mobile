// ============================================================================
// Luna's Baby Mobile - Reference Arm Recreation
// ============================================================================
// Recreated from "Gentle Rotating Baby Mobile" reference STL
// Original design analyzed and rebuilt parametrically in OpenSCAD
// ============================================================================

$fn = 64;

// ----------------------------------------------------------------------------
// ARM PARAMETERS (extracted from reference STL)
// ----------------------------------------------------------------------------

arm_thickness = 12;  // Z height

// Centerline path extracted from reference (normalized to origin)
// Format: [x, y] - the arm curves through XY plane
centerline = [
    [0.0, 0.0],
    [5.7, 4.3],
    [11.4, 3.1],
    [17.1, 7.3],
    [22.8, 12.5],
    [28.5, 23.7],
    [34.2, 37.6],
    [39.9, 48.6],
    [45.6, 57.0],
    [51.3, 65.0],
    [57.0, 73.7],
    [62.7, 81.4],
    [68.5, 88.1],
    [74.8, 94.7],
    [80.8, 101.2],
    [86.8, 107.4],
    [92.5, 112.8],
    [98.3, 118.1],
    [104.6, 123.9],
    [110.3, 121.9],
    [116.0, 124.5],
    [121.7, 127.3],
    [127.6, 139.0],
    [134.0, 145.6],
    [142.6, 151.4],
    [149.3, 155.4],
    [155.0, 158.7],
    [161.5, 157.7],
    [172.3, 162.2],
    [178.0, 146.5],
    [189.0, 153.7]
];

// Width at each centerline point (for the arm cross-section)
// Wider sections = hook locations
widths = [
    12.6,   // narrow start (mounting end)
    32.0,
    58.1,
    69.0,   // first hook area starts
    77.6,   // hook 1
    74.0,
    64.9,
    60.9,
    58.3,
    56.3,
    56.2,
    54.5,
    54.2,
    54.0,
    53.9,
    53.8,
    52.3,
    53.6,
    53.8,
    66.4,   // second hook area starts
    72.4,
    75.0,   // hook 2
    59.8,
    57.0,
    58.0,
    57.5,
    57.9,
    49.6,
    50.2,
    13.6,   // narrow tip
    19.8
];

// Hook positions (indices into centerline where hooks are)
hook_indices = [4, 21];  // At the widest points

// ----------------------------------------------------------------------------
// HELPER FUNCTIONS
// ----------------------------------------------------------------------------

// Linear interpolation
function lerp(a, b, t) = a + (b - a) * t;

// Get width at a specific index (clamped)
function get_width(i) = widths[min(max(0, i), len(widths)-1)];

// ----------------------------------------------------------------------------
// ARM BODY - Built by hulling cross-sections along the path
// ----------------------------------------------------------------------------

module arm_cross_section(width) {
    // Rounded rectangular cross-section (pill shape)
    hull() {
        translate([0, -width/2 + arm_thickness/2, 0])
            cylinder(h = arm_thickness, d = arm_thickness, center = true);
        translate([0, width/2 - arm_thickness/2, 0])
            cylinder(h = arm_thickness, d = arm_thickness, center = true);
    }
}

module arm_body() {
    for (i = [0:len(centerline)-2]) {
        p1 = centerline[i];
        p2 = centerline[i+1];
        w1 = get_width(i);
        w2 = get_width(i+1);
        
        hull() {
            translate([p1[0], p1[1], 0])
                arm_cross_section(w1);
            translate([p2[0], p2[1], 0])
                arm_cross_section(w2);
        }
    }
}

// ----------------------------------------------------------------------------
// INTEGRATED HOOKS
// ----------------------------------------------------------------------------

module hook(flip = false) {
    // C-shaped hook pointing downward (in -Z when arm is flat)
    hook_wire = 3;
    hook_inner_r = 4;
    hook_depth = 15;
    
    mirror([0, flip ? 1 : 0, 0])
    translate([0, 0, 0]) {
        // Stem connecting to arm
        cylinder(r = hook_wire/2, h = arm_thickness/2 + 2, $fn = 24);
        
        // C-curve
        translate([0, 0, -hook_depth + hook_inner_r])
        rotate([0, 90, -60])
        rotate_extrude(angle = 240, $fn = 48)
        translate([hook_inner_r, 0, 0])
            circle(d = hook_wire, $fn = 16);
    }
}

module hooks_at_position(idx) {
    p = centerline[idx];
    w = get_width(idx);
    
    translate([p[0], p[1], -arm_thickness/2]) {
        // Two hooks, one on each side of the arm
        translate([0, -w/4, 0]) hook(false);
        translate([0, w/4, 0]) hook(true);
    }
}

// ----------------------------------------------------------------------------
// DECORATIVE CHANNEL (recessed groove along top)
// ----------------------------------------------------------------------------

module center_channel() {
    channel_width = 4;
    channel_depth = 2;
    
    for (i = [3:len(centerline)-4]) {
        p1 = centerline[i];
        p2 = centerline[i+1];
        
        hull() {
            translate([p1[0], p1[1], arm_thickness/2 - channel_depth/2])
                cylinder(h = channel_depth + 0.1, d = channel_width, center = true, $fn = 16);
            translate([p2[0], p2[1], arm_thickness/2 - channel_depth/2])
                cylinder(h = channel_depth + 0.1, d = channel_width, center = true, $fn = 16);
        }
    }
}

// ----------------------------------------------------------------------------
// COMPLETE ARM
// ----------------------------------------------------------------------------

module arm_reference() {
    difference() {
        union() {
            // Main arm body
            arm_body();
            
            // Integrated hooks at the wide points
            for (idx = hook_indices) {
                hooks_at_position(idx);
            }
        }
        
        // Subtract decorative channel
        center_channel();
    }
}

// ----------------------------------------------------------------------------
// PRINT ORIENTATION
// ----------------------------------------------------------------------------

module arm_reference_print() {
    // Rotate for optimal printing - flat on the curved side
    // This puts the hooks pointing sideways for easy printing
    rotate([0, 0, 0])  // Already in good orientation (XY plane)
        arm_reference();
}

// ----------------------------------------------------------------------------
// RENDER
// ----------------------------------------------------------------------------

arm_reference_print();
