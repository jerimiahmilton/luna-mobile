// ============================================================================
// Luna's Baby Mobile - Power Distribution Board (PDB) Mount
// ============================================================================
// Mount for IA005 Power Distribution Board
// - Clean power management for motor and accessories
// - Overcurrent protection with LED indicator
// - Master switch input and 4 device outputs
// ============================================================================

include <config.scad>

// ----------------------------------------------------------------------------
// IA005 POWER DISTRIBUTION BOARD SPECIFICATIONS
// ----------------------------------------------------------------------------
pdb_length = 53;                    // Board length (mm)
pdb_width = 10;                     // Board width (mm)  
pdb_height = 10;                    // Board height (mm)
pdb_weight = 3;                     // Weight in grams

// Mounting holes
pdb_mount_hole_diameter = 2;        // M2 screw holes
pdb_mount_hole_spacing = 45;        // Distance between mounting holes (estimated)
pdb_mount_hole_edge_offset = 4;     // Distance from board edge to hole center

// Electrical specifications
pdb_max_current = 1000;             // Maximum current (mA)
pdb_max_voltage = 7.4;              // Maximum voltage (V)

// Connectors
// IN/OUT: PH2.0-2P (power input and daisy chain)
// SW0-4: SH1.0-2P (switch inputs, SW0 is master)
// CH1-4: SH1.0-2P (device outputs)

// Mount parameters
pdb_mount_wall = 2.5;               // Wall thickness
pdb_mount_clearance = 0.3;          // Clearance around board
pdb_mount_base_height = 3;          // Base plate thickness
pdb_mount_screw_hole_d = 2 + tolerance;  // M2 through-hole

// Cable routing
cable_channel_width = 8;            // Width of cable routing channel
cable_channel_depth = 3;            // Depth of channel

// Assembly mounting
pdb_assembly_hole_diameter = 3;     // M3 holes for mounting to assembly
pdb_assembly_hole_spacing_x = 65;   // X spacing of assembly mount holes
pdb_assembly_hole_spacing_y = 20;   // Y spacing of assembly mount holes

// ----------------------------------------------------------------------------
// MAIN PDB MOUNT MODULE
// ----------------------------------------------------------------------------

module pdb_mount() {
    // Overall dimensions
    mount_length = pdb_length + pdb_mount_wall * 2 + pdb_mount_clearance * 2;
    mount_width = pdb_width + pdb_mount_wall * 2 + pdb_mount_clearance * 2;
    mount_height = pdb_mount_base_height + pdb_height + pdb_mount_wall;
    
    difference() {
        union() {
            // Main body
            rounded_box(mount_length, mount_width, mount_height, 3);
            
            // Mounting tabs (4 corners)
            pdb_mounting_tabs(mount_length, mount_width, mount_height);
        }
        
        // Board pocket
        translate([0, 0, pdb_mount_base_height])
        cube([pdb_length + pdb_mount_clearance * 2, 
              pdb_width + pdb_mount_clearance * 2, 
              pdb_height + 10], center = true);
        
        // M2 mounting screw holes for board
        for (x = [-1, 1]) {
            translate([x * pdb_mount_hole_spacing / 2, 0, -1])
            cylinder(d = pdb_mount_screw_hole_d, h = pdb_mount_base_height + 2);
            
            // Countersink from bottom (for screw heads)
            translate([x * pdb_mount_hole_spacing / 2, 0, -0.1])
            cylinder(d1 = 4.5, d2 = pdb_mount_screw_hole_d, h = 2);
        }
        
        // Cable routing channels (both ends for connectors)
        // Input side (PH2.0 connectors)
        translate([-(mount_length/2 + 1), 0, pdb_mount_base_height + pdb_height/2])
        rotate([0, 90, 0])
        rounded_slot(cable_channel_width, cable_channel_depth, pdb_mount_wall + 2);
        
        // Output side (SH1.0 connectors)
        translate([(mount_length/2 - pdb_mount_wall - 1), 0, pdb_mount_base_height + pdb_height/2])
        rotate([0, 90, 0])
        rounded_slot(cable_channel_width, cable_channel_depth, pdb_mount_wall + 2);
        
        // Side cable channels (for switches)
        for (y = [-1, 1]) {
            translate([0, y * (mount_width/2 + 1), pdb_mount_base_height + pdb_height/2])
            rotate([90, 0, 0])
            rounded_slot(cable_channel_width * 1.5, cable_channel_depth, pdb_mount_wall + 2);
        }
        
        // LED viewing window (top center - for status LED)
        translate([0, 0, mount_height - pdb_mount_wall])
        cylinder(d = 4, h = pdb_mount_wall + 1);
        
        // Assembly mounting holes in tabs
        pdb_assembly_holes(mount_length, mount_width);
    }
    
    // Board retention clips
    pdb_retention_clips(mount_length, mount_width);
}

// ----------------------------------------------------------------------------
// MOUNTING TABS
// ----------------------------------------------------------------------------

module pdb_mounting_tabs(mount_length, mount_width, mount_height) {
    tab_width = 12;
    tab_length = 10;
    
    // Four corner tabs
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            translate([x * (mount_length/2 + tab_length/2 - 2), 
                       y * (mount_width/2 - tab_width/2 + 4), 
                       0])
            hull() {
                translate([0, 0, 0])
                cylinder(d = tab_width, h = pdb_mount_base_height);
                translate([-x * (tab_length - 2), 0, 0])
                cylinder(d = tab_width, h = pdb_mount_base_height);
            }
        }
    }
}

// ----------------------------------------------------------------------------
// ASSEMBLY HOLES (in tabs)
// ----------------------------------------------------------------------------

module pdb_assembly_holes(mount_length, mount_width) {
    tab_length = 10;
    
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            translate([x * (mount_length/2 + tab_length/2), 
                       y * (mount_width/2 - 2), 
                       -1])
            cylinder(d = pdb_assembly_hole_diameter + tolerance, h = pdb_mount_base_height + 2);
        }
    }
}

// ----------------------------------------------------------------------------
// RETENTION CLIPS
// ----------------------------------------------------------------------------

module pdb_retention_clips(mount_length, mount_width) {
    clip_width = 6;
    clip_height = pdb_mount_base_height + pdb_height - 1;
    clip_overhang = 1.5;
    
    // Two clips on long sides
    for (y = [-1, 1]) {
        translate([0, 
                   y * (pdb_width/2 + pdb_mount_clearance + pdb_mount_wall/2 - 0.5), 
                   0]) {
            // Clip arm
            cube([clip_width, 1.5, clip_height - 1], center = true);
            
            // Retention lip
            translate([0, -y * clip_overhang/2, clip_height/2 - 0.5])
            rotate([y * 15, 0, 0])
            cube([clip_width, clip_overhang + 1, 1.5], center = true);
        }
    }
}

// ----------------------------------------------------------------------------
// PDB DUMMY (for visualization)
// ----------------------------------------------------------------------------

module pdb_dummy() {
    color([0.1, 0.4, 0.2]) {
        // Main PCB
        cube([pdb_length, pdb_width, 1.6], center = true);
        
        // Components on top
        translate([0, 0, 2])
        color([0.2, 0.2, 0.2])
        cube([pdb_length - 6, pdb_width - 2, 3], center = true);
        
        // Status LED (white when normal)
        translate([0, 0, 4])
        color([1, 1, 1, 0.9])
        cylinder(d = 3, h = 2);
        
        // Connectors (simplified)
        // PH2.0 input
        translate([-(pdb_length/2 - 3), 0, 2])
        color([0.9, 0.9, 0.85])
        cube([5, 6, 4], center = true);
        
        // SH1.0 outputs (multiple)
        for (i = [0:3]) {
            translate([(pdb_length/2 - 3 - i * 8), pdb_width/2 - 1, 2])
            color([0.9, 0.9, 0.85])
            cube([4, 3, 3], center = true);
        }
    }
}

// ----------------------------------------------------------------------------
// HELPER MODULES
// ----------------------------------------------------------------------------

module rounded_box(length, width, height, radius) {
    hull() {
        for (x = [-1, 1]) {
            for (y = [-1, 1]) {
                translate([x * (length/2 - radius), y * (width/2 - radius), 0])
                cylinder(r = radius, h = height);
            }
        }
    }
}

module rounded_slot(width, depth, length) {
    hull() {
        for (y = [-1, 1]) {
            translate([0, y * (width/2 - depth/2), 0])
            cylinder(d = depth, h = length);
        }
    }
}

// ----------------------------------------------------------------------------
// PRINT ORIENTATION MODULE
// ----------------------------------------------------------------------------

module pdb_mount_printable() {
    // Mount prints flat, no supports needed
    pdb_mount();
}

// ----------------------------------------------------------------------------
// RENDER
// ----------------------------------------------------------------------------

if ($preview) {
    pdb_mount();
    
    // Show PDB in position
    translate([0, 0, pdb_mount_base_height + pdb_height/2])
    pdb_dummy();
} else {
    pdb_mount_printable();
}
