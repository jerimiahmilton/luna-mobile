// ============================================================================
// Luna's Baby Mobile - DC Barrel Jack Mount
// ============================================================================
// Panel mount for 5.5×2.1mm DC Barrel Jack (XC008)
// Standard panel hole: 12mm diameter
// For optional wall power input
// ============================================================================

include <config.scad>

// ----------------------------------------------------------------------------
// BARREL JACK CONFIGURATION
// ----------------------------------------------------------------------------

// Panel mount specifications
jack_hole_diameter = barrel_jack_panel_hole;          // 12mm standard
jack_flange_d = barrel_jack_flange_diameter;          // 14mm flange
jack_body_length = barrel_jack_body_length;           // 14mm behind panel
jack_nut_depth = barrel_jack_nut_depth;               // 3mm nut

// Mount wall thickness
wall = 3;

// ----------------------------------------------------------------------------
// PANEL MOUNT BRACKET
// ----------------------------------------------------------------------------
// Simple bracket to panel-mount the barrel jack

module barrel_jack_panel_mount() {
    bracket_width = jack_flange_d + 10;
    bracket_height = jack_flange_d + 10;
    bracket_depth = jack_body_length + wall + 5;
    
    difference() {
        union() {
            // Main bracket body
            cube([bracket_width, bracket_depth, bracket_height]);
            
            // Mounting ears
            for (z = [-1, 1]) {
                translate([bracket_width/2, 0, bracket_height/2 + z * (bracket_height/2 + 5)])
                rotate([-90, 0, 0])
                cylinder(d = 14, h = wall);
            }
        }
        
        // Jack hole (front panel)
        translate([bracket_width/2, -1, bracket_height/2])
        rotate([-90, 0, 0])
        cylinder(d = jack_hole_diameter + tolerance, h = wall + 2);
        
        // Jack body clearance (behind panel)
        translate([bracket_width/2, wall, bracket_height/2])
        rotate([-90, 0, 0])
        cylinder(d = jack_flange_d + 2, h = bracket_depth);
        
        // Wire exit (back)
        translate([bracket_width/2, bracket_depth - 1, bracket_height/2])
        rotate([-90, 0, 0])
        cylinder(d = 8, h = wall + 2);
        
        // Mounting screw holes
        for (z = [-1, 1]) {
            translate([bracket_width/2, -1, bracket_height/2 + z * (bracket_height/2 + 5)])
            rotate([-90, 0, 0])
            cylinder(d = 3 + tolerance, h = wall + 2);
        }
    }
}

// ----------------------------------------------------------------------------
// FLUSH PANEL MOUNT
// ----------------------------------------------------------------------------
// Thinner mount for embedding in an existing panel

module barrel_jack_flush_mount() {
    mount_d = jack_flange_d + 8;
    mount_h = wall + jack_nut_depth;
    
    difference() {
        // Cylindrical mount body
        cylinder(d = mount_d, h = mount_h);
        
        // Jack hole
        translate([0, 0, -1])
        cylinder(d = jack_hole_diameter + tolerance, h = mount_h + 2);
        
        // Flange recess (front)
        translate([0, 0, mount_h - 1])
        cylinder(d = jack_flange_d + 1, h = 2);
        
        // Nut recess (back, for tightening)
        translate([0, 0, -1])
        cylinder(d = jack_flange_d + 1, h = jack_nut_depth + 1);
        
        // Mounting screw holes
        for (a = [0, 90, 180, 270]) {
            rotate([0, 0, a])
            translate([mount_d/2 - 3, 0, -1])
            cylinder(d = 2.5, h = mount_h + 2);
        }
    }
}

// ----------------------------------------------------------------------------
// BARREL JACK CUTOUT (for embedding)
// ----------------------------------------------------------------------------
// Use this as a negative shape in your housing

module barrel_jack_cutout() {
    // Through hole
    cylinder(d = jack_hole_diameter + tolerance, h = 50, center = true);
    
    // Flange recess (front side)
    translate([0, 0, wall/2])
    cylinder(d = jack_flange_d + 1, h = 2);
    
    // Body clearance (back side)
    translate([0, 0, -jack_body_length - 5])
    cylinder(d = jack_flange_d + 2, h = jack_body_length + 5);
}

// ----------------------------------------------------------------------------
// BARREL JACK 3D MODEL (Parametric)
// ----------------------------------------------------------------------------
// Since no STEP model is available, this is a parametric model
// based on standard 5521 barrel jack dimensions

module barrel_jack_model() {
    color([0.2, 0.2, 0.2]) {
        // Main body (cylindrical, behind panel)
        translate([0, 0, -jack_body_length + 2])
        cylinder(d = 10, h = jack_body_length);
        
        // Panel flange/collar
        translate([0, 0, -2])
        cylinder(d = jack_flange_d, h = 4);
        
        // Threaded section (for nut)
        translate([0, 0, 2])
        cylinder(d = jack_hole_diameter - 0.5, h = jack_nut_depth + 2);
        
        // Socket opening
        translate([0, 0, jack_nut_depth + 2])
        difference() {
            cylinder(d = barrel_jack_plug_outer + 2, h = 3);
            translate([0, 0, 0.5])
            cylinder(d = barrel_jack_plug_outer, h = 3);
        }
    }
    
    // Center pin (visible in socket)
    color([0.9, 0.7, 0.2])
    translate([0, 0, jack_nut_depth + 2])
    cylinder(d = barrel_jack_plug_inner, h = 3);
    
    // Wires
    color([0.8, 0.1, 0.1])
    translate([3, 0, -jack_body_length - 5])
    cylinder(d = 1.5, h = barrel_jack_wire_length);
    
    color([0.1, 0.1, 0.1])
    translate([-3, 0, -jack_body_length - 5])
    cylinder(d = 1.5, h = barrel_jack_wire_length);
}

// ----------------------------------------------------------------------------
// COMBINATION PANEL WITH JACK AND SWITCH
// ----------------------------------------------------------------------------
// Panel that holds both the barrel jack and power switch

module power_panel() {
    panel_w = 70;
    panel_h = 40;
    panel_d = wall;
    
    difference() {
        // Panel base
        cube([panel_w, panel_d, panel_h]);
        
        // Barrel jack hole
        translate([panel_w * 0.3, -1, panel_h/2])
        rotate([-90, 0, 0])
        cylinder(d = jack_hole_diameter + tolerance, h = panel_d + 2);
        
        // Switch window (placeholder - adjust based on actual switch)
        translate([panel_w * 0.7 - 8, -1, panel_h/2 - 5])
        cube([16, panel_d + 2, 10]);
        
        // Mounting holes
        for (x = [8, panel_w - 8]) {
            for (z = [8, panel_h - 8]) {
                translate([x, -1, z])
                rotate([-90, 0, 0])
                cylinder(d = 3 + tolerance, h = panel_d + 2);
            }
        }
    }
    
    // Labels (embossed)
    translate([panel_w * 0.3, 0, panel_h/2 + jack_hole_diameter/2 + 3])
    rotate([90, 0, 0])
    linear_extrude(height = 0.5)
    text("DC IN", size = 4, halign = "center", valign = "bottom");
    
    translate([panel_w * 0.7, 0, panel_h/2 + 10])
    rotate([90, 0, 0])
    linear_extrude(height = 0.5)
    text("POWER", size = 4, halign = "center", valign = "bottom");
}

// ----------------------------------------------------------------------------
// RENDER
// ----------------------------------------------------------------------------

if ($preview) {
    // Panel mount bracket
    barrel_jack_panel_mount();
    
    // Show jack in position
    translate([jack_flange_d/2 + 5, wall, (jack_flange_d + 10)/2])
    rotate([-90, 0, 0])
    barrel_jack_model();
    
    // Alternative: show power panel
    // translate([100, 0, 0]) power_panel();
} else {
    barrel_jack_panel_mount();
}

// Uncomment to export specific parts:
// barrel_jack_panel_mount();
// barrel_jack_flush_mount();
// power_panel();
// barrel_jack_model();  // For visualization only
