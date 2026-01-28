// ============================================================================
// Luna's Baby Mobile - Configuration File
// ============================================================================
// A gift for Jeremy's newborn daughter 💕
// All dimensions in millimeters
// ============================================================================

// ----------------------------------------------------------------------------
// PRINT SETTINGS & TOLERANCES
// ----------------------------------------------------------------------------
$fn = 64;                           // Resolution for curves (increase for final render)
tolerance = 0.2;                    // General fit tolerance
press_fit_tolerance = 0.15;         // Tighter tolerance for press fits
loose_fit_tolerance = 0.3;          // Looser tolerance for easy assembly
layer_height = 0.2;                 // Assumed layer height for design decisions

// ----------------------------------------------------------------------------
// 608 BEARING SPECIFICATIONS (Standard skateboard bearing)
// ----------------------------------------------------------------------------
bearing_inner_diameter = 8;         // Inner bore diameter
bearing_outer_diameter = 22;        // Outer race diameter
bearing_width = 7;                  // Bearing width/thickness
bearing_chamfer = 0.5;              // Small chamfer on bearing edges

// ----------------------------------------------------------------------------
// N20 WORM GEAR MOTOR SPECIFICATIONS (B-LA009)
// ----------------------------------------------------------------------------
motor_body_length = 24;             // Main motor body length (excluding gearbox)
motor_body_diameter = 12;           // Motor body diameter
motor_gearbox_length = 9.2;         // Worm gearbox length
motor_gearbox_width = 12;           // Gearbox width
motor_gearbox_height = 10;          // Gearbox height
motor_total_length = 33.2;          // Total motor + gearbox length
motor_shaft_diameter = 4;           // Output shaft diameter
motor_shaft_flat_depth = 0.5;       // D-flat depth
motor_shaft_length = 10;            // Output shaft length
motor_mounting_hole_spacing = 8;    // Distance between mounting holes (if applicable)
motor_rpm = 150;                    // RPM at 3V

// ----------------------------------------------------------------------------
// GEAR SPECIFICATIONS
// ----------------------------------------------------------------------------
gear_module = 1.5;                  // Gear module (tooth size) - 1.5mm for printability
gear_pressure_angle = 20;           // Standard pressure angle
gear_backlash = 0.1;                // Backlash for smooth operation
gear_height = 8;                    // Gear thickness

// Two-stage reduction: 150 RPM -> ~30 RPM -> ~3 RPM
// Stage 1: 5:1 reduction (10 tooth pinion, 50 tooth gear)
pinion1_teeth = 10;
gear1_teeth = 50;
// Stage 2: 10:1 reduction (10 tooth pinion, 100 tooth gear)
pinion2_teeth = 10;
gear2_teeth = 100;

// Total reduction: 5 * 10 = 50:1 (150 RPM -> 3 RPM)
target_rpm = motor_rpm / (gear1_teeth/pinion1_teeth) / (gear2_teeth/pinion2_teeth);

// ----------------------------------------------------------------------------
// CENTRAL HUB SPECIFICATIONS
// ----------------------------------------------------------------------------
hub_outer_diameter = 60;            // Outer diameter of hub
hub_height = 20;                    // Total hub height
hub_wall_thickness = 3;             // Wall thickness
hub_arm_count = 4;                  // Number of arms (evenly spaced)
hub_arm_socket_diameter = 10;       // Diameter of arm attachment socket
hub_arm_socket_depth = 12;          // Depth of arm socket

// ----------------------------------------------------------------------------
// ARM SPECIFICATIONS
// ----------------------------------------------------------------------------
arm_length = 180;                   // Arm length (parametric: 150-200mm recommended)
arm_width = 12;                     // Arm cross-section width
arm_thickness = 6;                  // Arm cross-section thickness
arm_plug_diameter = 10 - tolerance; // Plug diameter (matches socket)
arm_plug_length = 10;               // Length of plug that goes into hub
arm_hook_diameter = 8;              // Hook inner diameter for hanging elements
arm_hook_thickness = 4;             // Hook wire thickness

// ----------------------------------------------------------------------------
// CEILING MOUNT SPECIFICATIONS
// ----------------------------------------------------------------------------
ceiling_mount_width = 50;           // Width of ceiling plate
ceiling_mount_depth = 50;           // Depth of ceiling plate  
ceiling_mount_height = 35;          // Total height including bearing holder
ceiling_plate_thickness = 5;        // Thickness of mounting plate
ceiling_screw_diameter = 4;         // Mounting screw hole diameter
ceiling_screw_spacing = 35;         // Distance between mounting holes

// ----------------------------------------------------------------------------
// CRIB RAIL CLAMP SPECIFICATIONS
// ----------------------------------------------------------------------------
crib_rail_width_min = 25;           // Minimum crib rail width
crib_rail_width_max = 50;           // Maximum crib rail width (adjustable)
crib_rail_thickness = 30;           // Typical crib rail thickness
clamp_jaw_depth = 40;               // How far the clamp grips
clamp_body_width = 60;              // Width of clamp body
clamp_screw_diameter = 6;           // Adjustment screw diameter (M6)
clamp_padding = 3;                  // Rubber/foam padding allowance

// ----------------------------------------------------------------------------
// MOTOR MOUNT SPECIFICATIONS
// ----------------------------------------------------------------------------
motor_mount_wall = 2.5;             // Wall thickness around motor
motor_mount_base_height = 4;        // Base plate thickness
motor_mount_screw_diameter = 3;     // M3 mounting screws
motor_mount_screw_count = 4;        // Number of mounting holes

// ----------------------------------------------------------------------------
// AESTHETIC OPTIONS
// ----------------------------------------------------------------------------
fillet_radius = 2;                  // Radius for rounded edges
chamfer_size = 1;                   // Size of chamfers

// ----------------------------------------------------------------------------
// COLORS (for visualization)
// ----------------------------------------------------------------------------
color_hub = [0.95, 0.85, 0.95];     // Soft lavender
color_arms = [0.9, 0.95, 0.9];      // Mint green
color_mount = [0.95, 0.95, 0.9];    // Cream
color_motor = [0.3, 0.3, 0.35];     // Dark gray
color_bearing = [0.7, 0.7, 0.75];   // Silver
color_gears = [0.95, 0.9, 0.8];     // Warm white

// ----------------------------------------------------------------------------
// HELPER FUNCTIONS
// ----------------------------------------------------------------------------

// Calculate gear pitch diameter
function pitch_diameter(teeth, mod) = teeth * mod;

// Calculate gear outer diameter  
function outer_diameter(teeth, mod) = (teeth + 2) * mod;

// Calculate center distance between two meshing gears
function center_distance(teeth1, teeth2, mod) = (teeth1 + teeth2) * mod / 2;
