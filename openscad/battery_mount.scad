// ============================================================================
// Luna's Baby Mobile - Battery Case Mount
// ============================================================================
// Housing/bracket for 4xAA Battery Case with PH2.0 Connector (IA003)
// Dimensions: 70×65×19mm
// ============================================================================

include <config.scad>

// ----------------------------------------------------------------------------
// BATTERY MOUNT CONFIGURATION
// ----------------------------------------------------------------------------

// Mount style options
mount_style = "cradle";  // "cradle", "clip", or "enclosed"

// Internal dimensions (battery case + clearance)
case_length = battery_case_length + battery_mount_clearance * 2;
case_width = battery_case_width + battery_mount_clearance * 2;
case_height = battery_case_height + battery_mount_clearance;

// ----------------------------------------------------------------------------
// BATTERY CRADLE MOUNT
// ----------------------------------------------------------------------------
// Open cradle that holds the battery case with retention clips

module battery_cradle_mount() {
    wall = battery_mount_wall;
    tab_w = battery_mount_tab_width;
    lip_height = 5;
    
    difference() {
        union() {
            // Base plate
            rounded_rect(case_length + wall * 2, case_width + wall * 2, wall, 3);
            
            // Side walls (partial - open for access)
            for (x = [-1, 1]) {
                translate([x * (case_length/2 + wall/2), 0, 0])
                cube([wall, case_width + wall * 2, case_height + wall], center = true);
            }
            
            // End walls with retention lips
            for (y = [-1, 1]) {
                translate([0, y * (case_width/2 + wall/2), 0])
                difference() {
                    // Wall
                    cube([case_length + wall * 2, wall, case_height + wall], center = true);
                    
                    // Wire exit notch (one end only)
                    if (y > 0) {
                        translate([0, 0, case_height/2 + wall])
                        cube([15, wall + 2, 10], center = true);
                    }
                }
                
                // Retention lips
                translate([0, y * (case_width/2 - 2), case_height/2 + wall/2])
                rotate([0, 0, y > 0 ? 0 : 180])
                retention_lip(case_length - 20, lip_height);
            }
            
            // Corner retention clips
            for (x = [-1, 1]) {
                for (y = [-1, 1]) {
                    translate([x * (case_length/2 - 10), y * (case_width/2 - 5), 0])
                    corner_clip(case_height);
                }
            }
            
            // Mounting tabs
            for (x = [-1, 1]) {
                translate([x * (case_length/2 + wall + 8), 0, 0])
                mounting_tab();
            }
        }
        
        // Battery case pocket
        translate([0, 0, wall + case_height/2])
        cube([case_length, case_width, case_height + 1], center = true);
    }
}

// Retention lip module
module retention_lip(length, height) {
    rotate([45, 0, 0])
    cube([length, 2, 2], center = true);
}

// Corner retention clip
module corner_clip(height) {
    clip_w = 8;
    clip_d = 5;
    lip = 2;
    
    translate([0, 0, height/2])
    difference() {
        cube([clip_w, clip_d, height], center = true);
        translate([0, -lip, lip])
        cube([clip_w + 1, clip_d, height], center = true);
    }
}

// Mounting tab with screw hole
module mounting_tab() {
    tab_d = 16;
    tab_h = battery_mount_wall;
    
    difference() {
        cylinder(d = tab_d, h = tab_h);
        translate([0, 0, -1])
        cylinder(d = 3 + tolerance, h = tab_h + 2);
        // Countersink
        translate([0, 0, tab_h - 1.5])
        cylinder(d1 = 3, d2 = 6, h = 2);
    }
}

// Helper for rounded rectangle
module rounded_rect(w, d, h, r) {
    hull() {
        for (x = [-w/2 + r, w/2 - r]) {
            for (y = [-d/2 + r, d/2 - r]) {
                translate([x, y, 0])
                cylinder(r = r, h = h);
            }
        }
    }
}

// ----------------------------------------------------------------------------
// BATTERY CLIP MOUNT (Alternative style)
// ----------------------------------------------------------------------------
// Minimal clip-style mount for space-constrained installations

module battery_clip_mount() {
    wall = battery_mount_wall;
    clip_height = 12;
    
    // Base plate
    rounded_rect(case_length + wall * 2, case_width + wall * 2, wall, 3);
    
    // End clips
    for (y = [-1, 1]) {
        translate([0, y * (case_width/2 + wall/2), wall])
        end_clip(case_length - 10, clip_height);
    }
    
    // Corner posts
    for (x = [-1, 1]) {
        for (y = [-1, 1]) {
            translate([x * (case_length/2 - 5), y * (case_width/2 - 5), wall])
            cylinder(d = 6, h = 8);
        }
    }
}

module end_clip(width, height) {
    // Vertical wall
    translate([0, 0, height/2])
    cube([width, battery_mount_wall, height], center = true);
    
    // Inward lip
    translate([0, -2, height - 1])
    cube([width, 4, 2], center = true);
}

// ----------------------------------------------------------------------------
// BATTERY ENCLOSED MOUNT (Full enclosure)
// ----------------------------------------------------------------------------
// Fully enclosed battery housing with lid

module battery_enclosed_mount() {
    wall = battery_mount_wall;
    
    // Main enclosure
    difference() {
        // Outer shell
        rounded_rect(case_length + wall * 2, case_width + wall * 2, case_height + wall * 2, 5);
        
        // Battery pocket
        translate([0, 0, wall])
        rounded_rect(case_length, case_width, case_height + wall + 1, 3);
        
        // Wire exit hole
        translate([0, case_width/2 + wall, wall + case_height/2])
        rotate([90, 0, 0])
        cylinder(d = 8, h = wall + 2);
        
        // Lid screw holes
        for (x = [-1, 1]) {
            for (y = [-1, 1]) {
                translate([x * (case_length/2 - 5), y * (case_width/2 - 5), -1])
                cylinder(d = 2.5, h = case_height + wall * 2 + 2);
            }
        }
    }
}

module battery_enclosure_lid() {
    wall = battery_mount_wall;
    lid_h = wall;
    
    difference() {
        union() {
            // Main lid
            rounded_rect(case_length + wall * 2, case_width + wall * 2, lid_h, 5);
            
            // Alignment lip
            translate([0, 0, lid_h])
            rounded_rect(case_length - 1, case_width - 1, 2, 2);
        }
        
        // Screw holes
        for (x = [-1, 1]) {
            for (y = [-1, 1]) {
                translate([x * (case_length/2 - 5), y * (case_width/2 - 5), -1])
                cylinder(d = 3.2, h = lid_h + 4);
            }
        }
    }
}

// ----------------------------------------------------------------------------
// BATTERY CASE DUMMY (for visualization)
// ----------------------------------------------------------------------------

module battery_case_dummy() {
    color(color_battery) {
        // Main case body
        cube([battery_case_length, battery_case_width, battery_case_height], center = true);
        
        // Wire/connector
        translate([0, battery_case_width/2 + 5, 0])
        rotate([90, 0, 0])
        cylinder(d = 4, h = 10);
    }
}

// ----------------------------------------------------------------------------
// RENDER
// ----------------------------------------------------------------------------

if ($preview) {
    // Show chosen mount style
    if (mount_style == "cradle") {
        battery_cradle_mount();
    } else if (mount_style == "clip") {
        battery_clip_mount();
    } else {
        battery_enclosed_mount();
    }
    
    // Show battery case in position
    translate([0, 0, battery_mount_wall + battery_case_height/2 + battery_mount_clearance])
    battery_case_dummy();
} else {
    // Export cradle mount by default
    battery_cradle_mount();
}

// Uncomment to export specific parts:
// battery_cradle_mount();
// battery_clip_mount();
// battery_enclosed_mount();
// battery_enclosure_lid();
