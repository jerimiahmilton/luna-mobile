// ============================================================================
// Luna's Baby Mobile - Power Switch Mount
// ============================================================================
// Mount/bracket for Power Switch Board (XA007)
// Dimensions: 29×13×15.2mm with XH2.54 2-Pin Connector
// ============================================================================

include <config.scad>

// ----------------------------------------------------------------------------
// SWITCH MOUNT CONFIGURATION
// ----------------------------------------------------------------------------

// Internal dimensions (switch + clearance)
switch_pocket_length = switch_length + switch_mount_clearance * 2;
switch_pocket_width = switch_width + switch_mount_clearance * 2;
switch_pocket_height = switch_height + switch_mount_clearance;

// Mount wall thickness
wall = switch_mount_wall;

// ----------------------------------------------------------------------------
// PANEL MOUNT BRACKET
// ----------------------------------------------------------------------------
// Mounts the switch to a panel/housing with the actuator accessible

module switch_panel_mount() {
    bracket_length = switch_pocket_length + wall * 2;
    bracket_width = switch_pocket_width + wall * 2;
    bracket_height = switch_pocket_height + wall;
    
    // Actuator window dimensions (where the switch toggle is)
    actuator_window_length = 15;
    actuator_window_width = 8;
    
    difference() {
        union() {
            // Main bracket body
            rounded_box(bracket_length, bracket_width, bracket_height, 2);
            
            // Mounting flanges
            for (x = [-1, 1]) {
                translate([x * (bracket_length/2 + 8), bracket_width/2, 0])
                cylinder(d = 12, h = wall);
            }
        }
        
        // Switch pocket (open bottom)
        translate([wall, wall, -1])
        cube([switch_pocket_length, switch_pocket_width, switch_pocket_height + 1]);
        
        // Actuator access window (top)
        translate([bracket_length/2 - actuator_window_length/2, 
                   bracket_width/2 - actuator_window_width/2, 
                   bracket_height - wall - 1])
        cube([actuator_window_length, actuator_window_width, wall + 2]);
        
        // Wire exit slot
        translate([bracket_length - wall - 1, bracket_width/2 - 4, wall])
        cube([wall + 2, 8, switch_pocket_height]);
        
        // Mounting screw holes
        for (x = [-1, 1]) {
            translate([bracket_length/2 + x * (bracket_length/2 + 8), bracket_width/2, -1])
            cylinder(d = 3 + tolerance, h = wall + 2);
        }
    }
    
    // Retention clips inside pocket
    for (y = [wall + 2, bracket_width - wall - 2]) {
        translate([bracket_length/2, y, wall])
        switch_retention_clip();
    }
}

// Small retention clip
module switch_retention_clip() {
    clip_w = 6;
    clip_h = 4;
    
    difference() {
        cube([clip_w, 2, clip_h], center = true);
        translate([0, 1.5, 1])
        rotate([30, 0, 0])
        cube([clip_w + 1, 3, 3], center = true);
    }
}

// Rounded box helper
module rounded_box(l, w, h, r) {
    hull() {
        for (x = [r, l-r]) {
            for (y = [r, w-r]) {
                translate([x, y, 0])
                cylinder(r = r, h = h);
            }
        }
    }
}

// ----------------------------------------------------------------------------
// SNAP-IN MOUNT
// ----------------------------------------------------------------------------
// Simple snap-fit mount for quick installation

module switch_snap_mount() {
    base_length = switch_pocket_length + wall * 2;
    base_width = switch_pocket_width + wall * 2;
    
    // Base plate
    cube([base_length, base_width, wall]);
    
    // Side rails with snap lips
    for (x = [0, base_length - wall]) {
        translate([x, 0, wall])
        difference() {
            cube([wall, base_width, switch_height - 5]);
            // Angled entry
            translate([-1, -1, switch_height - 8])
            rotate([0, 30, 0])
            cube([5, base_width + 2, 5]);
        }
        
        // Snap lip
        translate([x + (x == 0 ? wall - 0.5 : 0.5), 0, switch_height - 5])
        cube([1, base_width, 2]);
    }
    
    // Wire guide
    translate([base_length, base_width/2 - 4, 0])
    cube([10, 8, wall]);
}

// ----------------------------------------------------------------------------
// INTEGRATED HOUSING CUTOUT (for embedding in another part)
// ----------------------------------------------------------------------------
// Use this as a negative to create a switch pocket in another housing

module switch_cutout() {
    // Main switch pocket
    cube([switch_pocket_length, switch_pocket_width, switch_pocket_height]);
    
    // Actuator clearance (extends upward)
    translate([switch_pocket_length/2 - 8, switch_pocket_width/2 - 5, switch_pocket_height - 1])
    cube([16, 10, 10]);
    
    // Wire exit channel
    translate([switch_pocket_length - 1, switch_pocket_width/2 - 5, 0])
    cube([10, 10, switch_pocket_height/2]);
}

// ----------------------------------------------------------------------------
// SWITCH MODULE DUMMY (for visualization)
// ----------------------------------------------------------------------------

module switch_dummy() {
    color(color_switch) {
        // PCB base
        cube([switch_length, switch_width, 2], center = true);
        
        // Switch body
        translate([0, 0, 2])
        cube([15, 10, 8], center = true);
        
        // Actuator/toggle
        translate([0, 0, 6 + switch_actuator_height/2])
        cube([8, 6, switch_actuator_height], center = true);
        
        // Connector
        translate([switch_length/2 - 3, 0, -2])
        cube([6, 8, 4], center = true);
    }
}

// ----------------------------------------------------------------------------
// RENDER
// ----------------------------------------------------------------------------

if ($preview) {
    switch_panel_mount();
    
    // Show switch in position
    translate([switch_mount_wall + switch_mount_clearance + switch_length/2, 
               switch_mount_wall + switch_mount_clearance + switch_width/2, 
               switch_mount_wall + switch_height/2])
    switch_dummy();
} else {
    switch_panel_mount();
}

// Uncomment to export specific parts:
// switch_panel_mount();
// switch_snap_mount();
