// ============================================================================
// Luna's Baby Mobile - Ceiling Mount
// ============================================================================
// Clean ceiling attachment with integrated bearing holder
// The bearing outer race is held fixed while the hub rotates inside
// ============================================================================

include <config.scad>

// ----------------------------------------------------------------------------
// CEILING MOUNT MODULE
// ----------------------------------------------------------------------------

module ceiling_mount() {
    color(color_mount)
    difference() {
        union() {
            // Main mounting plate
            ceiling_plate();
            
            // Bearing holder (hangs down from plate)
            translate([0, 0, -ceiling_mount_height + ceiling_plate_thickness])
            bearing_holder();
            
            // Decorative collar around bearing holder
            translate([0, 0, -5])
            cylinder(d1 = bearing_outer_diameter + 20, 
                     d2 = bearing_outer_diameter + 12, h = 5);
        }
        
        // Mounting screw holes
        for (pos = mounting_hole_positions()) {
            translate([pos[0], pos[1], -1])
            cylinder(d = ceiling_screw_diameter + tolerance, h = ceiling_plate_thickness + 2);
            
            // Countersink
            translate([pos[0], pos[1], ceiling_plate_thickness - 2])
            cylinder(d1 = ceiling_screw_diameter + tolerance, 
                     d2 = ceiling_screw_diameter + 4, h = 2.5);
        }
        
        // Bearing press-fit seat
        translate([0, 0, -ceiling_mount_height + ceiling_plate_thickness + 3])
        cylinder(d = bearing_outer_diameter + press_fit_tolerance, h = bearing_width + 1);
        
        // Center hole for shaft/wiring
        translate([0, 0, -ceiling_mount_height - 1])
        cylinder(d = bearing_inner_diameter + 2, h = ceiling_mount_height + ceiling_plate_thickness + 2);
    }
}

// Ceiling mounting plate
module ceiling_plate() {
    hull() {
        for (pos = mounting_hole_positions()) {
            translate([pos[0], pos[1], 0])
            cylinder(d = 12, h = ceiling_plate_thickness);
        }
        cylinder(d = bearing_outer_diameter + 16, h = ceiling_plate_thickness);
    }
}

// Bearing holder cup
module bearing_holder() {
    holder_h = ceiling_mount_height - ceiling_plate_thickness;
    wall = 4;
    
    difference() {
        // Outer shell
        union() {
            cylinder(d = bearing_outer_diameter + wall * 2, h = holder_h);
            
            // Bottom lip to retain bearing
            cylinder(d = bearing_outer_diameter + wall * 2 + 4, h = 3);
        }
        
        // Bearing cavity (from bottom)
        translate([0, 0, 3])
        cylinder(d = bearing_outer_diameter + press_fit_tolerance, h = holder_h);
        
        // Center through-hole
        translate([0, 0, -1])
        cylinder(d = bearing_inner_diameter + 2, h = holder_h + 2);
    }
}

// Mounting hole positions
function mounting_hole_positions() = [
    [ceiling_screw_spacing/2, ceiling_screw_spacing/2],
    [-ceiling_screw_spacing/2, ceiling_screw_spacing/2],
    [ceiling_screw_spacing/2, -ceiling_screw_spacing/2],
    [-ceiling_screw_spacing/2, -ceiling_screw_spacing/2]
];

// ----------------------------------------------------------------------------
// CEILING MOUNT WITH INTEGRATED GEARBOX ATTACHMENT
// ----------------------------------------------------------------------------
// Version that includes mounting points for the gearbox

module ceiling_mount_motorized() {
    color(color_mount)
    union() {
        // Basic ceiling mount
        ceiling_mount();
        
        // Motor/gearbox mounting bracket
        translate([0, 0, -ceiling_mount_height + ceiling_plate_thickness])
        motor_bracket();
    }
}

// Bracket for attaching motor/gearbox
module motor_bracket() {
    bracket_l = 50;
    bracket_w = 30;
    bracket_h = 3;
    
    difference() {
        translate([-bracket_w/2, bearing_outer_diameter/2 + 5, 0])
        cube([bracket_w, bracket_l, bracket_h]);
        
        // Mounting holes for gearbox
        for (x = [-10, 10]) {
            translate([x, bearing_outer_diameter/2 + 15, -1])
            cylinder(d = 3.2, h = bracket_h + 2);
            
            translate([x, bearing_outer_diameter/2 + 40, -1])
            cylinder(d = 3.2, h = bracket_h + 2);
        }
    }
}

// ----------------------------------------------------------------------------
// DECORATIVE CEILING ROSE
// ----------------------------------------------------------------------------
// Optional decorative cover for a cleaner look

module ceiling_rose() {
    rose_d = 100;
    rose_h = 15;
    
    color(color_mount)
    difference() {
        // Dome shape
        scale([1, 1, 0.3])
        sphere(d = rose_d);
        
        // Flat bottom
        translate([-rose_d/2, -rose_d/2, -rose_d/2])
        cube([rose_d, rose_d, rose_d/2]);
        
        // Center hole for mount
        translate([0, 0, -1])
        cylinder(d = bearing_outer_diameter + 20, h = rose_h);
        
        // Screw access holes
        for (pos = mounting_hole_positions()) {
            translate([pos[0], pos[1], -1])
            cylinder(d = 8, h = rose_h);
        }
    }
}

// ----------------------------------------------------------------------------
// CEILING HOOK (Alternative simple mount)
// ----------------------------------------------------------------------------

module ceiling_hook() {
    hook_d = 8;
    hook_inner = 15;
    plate_d = 40;
    
    color(color_mount)
    union() {
        // Mounting plate
        difference() {
            cylinder(d = plate_d, h = ceiling_plate_thickness);
            
            for (a = [0, 120, 240]) {
                rotate([0, 0, a])
                translate([plate_d/2 - 8, 0, -1])
                cylinder(d = ceiling_screw_diameter + tolerance, h = ceiling_plate_thickness + 2);
            }
        }
        
        // Hook
        translate([0, 0, -hook_inner - hook_d])
        rotate_extrude(angle = 180)
        translate([hook_inner/2 + hook_d/2, 0, 0])
        circle(d = hook_d);
        
        // Hook stem
        translate([0, 0, ceiling_plate_thickness])
        rotate([180, 0, 0])
        cylinder(d = hook_d, h = hook_inner + hook_d + ceiling_plate_thickness);
        
        // Swivel ring attachment point
        translate([0, 0, -hook_inner - hook_d * 1.5])
        difference() {
            sphere(d = hook_d * 2);
            translate([0, 0, -hook_d])
            cube([hook_d * 3, hook_d * 3, hook_d * 2], center = true);
        }
    }
}

// ----------------------------------------------------------------------------
// RENDER
// ----------------------------------------------------------------------------

if ($preview) {
    ceiling_mount();
    // Optional: show with bearing
    translate([0, 0, -ceiling_mount_height + ceiling_plate_thickness + 3])
    %cylinder(d = bearing_outer_diameter, h = bearing_width);
} else {
    ceiling_mount();
}
