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
// N20 WORM GEAR MOTOR SPECIFICATIONS (B-LA008 - Single Shaft)
// ----------------------------------------------------------------------------
// Updated to single shaft worm gear motor for simpler design
motor_body_length = 24;             // Main motor body length (excluding gearbox)
motor_body_diameter = 12;           // Motor body diameter
motor_gearbox_length = 9.2;         // Worm gearbox length
motor_gearbox_width = 12;           // Gearbox width
motor_gearbox_height = 10;          // Gearbox height
motor_total_length = 33.2;          // Total motor + gearbox length
motor_shaft_diameter = 4;           // Output shaft diameter
motor_shaft_flat_depth = 0.5;       // D-flat depth
motor_shaft_length = 10;            // Output shaft length (single side only)
motor_mounting_hole_spacing = 8;    // Distance between mounting holes
motor_mounting_hole_diameter = 2;   // M2 mounting screw holes
motor_rpm = 30;                     // RPM at 6V (~25-34 RPM, design for 30)
motor_voltage = 6.0;                // Rated voltage (range: 3-7V)
motor_current = 30;                 // Max current in mA
motor_rotation = "CW";              // Clockwise rotation

// ----------------------------------------------------------------------------
// GEAR SPECIFICATIONS (SIMPLIFIED)
// ----------------------------------------------------------------------------
// With 30 RPM motor, we only need ~8:1 reduction for 3-4 RPM output
gear_module = 1.5;                  // Gear module (tooth size) - 1.5mm for printability
gear_pressure_angle = 20;           // Standard pressure angle
gear_backlash = 0.1;                // Backlash for smooth operation
gear_height = 8;                    // Gear thickness

// Single stage reduction: 30 RPM -> ~3.75 RPM
// 8:1 reduction (12 tooth pinion, 96 tooth gear)
pinion_teeth = 12;                  // Motor pinion (minimum practical size)
gear_teeth = 96;                    // Output gear
gear_ratio = gear_teeth / pinion_teeth;  // 8:1

// Target output RPM
target_rpm = motor_rpm / gear_ratio;  // 30 / 8 = 3.75 RPM

// ----------------------------------------------------------------------------
// BATTERY CASE SPECIFICATIONS (IA003 - 4xAA with PH2.0)
// ----------------------------------------------------------------------------
battery_case_length = 70;           // Length (along batteries)
battery_case_width = 65;            // Width
battery_case_height = 19;           // Height/thickness
battery_case_voltage = 6.0;         // 4x 1.5V in series
battery_connector_type = "PH2.0";   // JST PH2.0 connector

// Mounting dimensions
battery_mount_wall = 2.5;           // Wall thickness for mount
battery_mount_tab_width = 10;       // Width of retention tabs
battery_mount_clearance = 0.5;      // Extra clearance for easy insertion

// ----------------------------------------------------------------------------
// POWER SWITCH SPECIFICATIONS (XA007)
// ----------------------------------------------------------------------------
switch_length = 29;                 // Length of switch module
switch_width = 13;                  // Width
switch_height = 15.2;               // Height (includes actuator)
switch_connector_type = "XH2.54";   // XH2.54 2-pin connector
switch_max_voltage = 12.6;          // Maximum voltage
switch_max_current = 3000;          // Maximum current in mA (3A)

// Mounting dimensions
switch_mount_wall = 2;              // Wall thickness
switch_actuator_height = 8;         // Height of switch actuator above base
switch_mount_clearance = 0.3;       // Clearance for fit

// ----------------------------------------------------------------------------
// DC BARREL JACK SPECIFICATIONS (XC008 - 5.5x2.1mm)
// ----------------------------------------------------------------------------
barrel_jack_plug_outer = 5.5;       // Plug outer diameter
barrel_jack_plug_inner = 2.1;       // Plug inner diameter (center pin)
barrel_jack_panel_hole = 12;        // Panel mount hole diameter
barrel_jack_body_length = 14;       // Body length behind panel
barrel_jack_flange_diameter = 14;   // Mounting flange diameter
barrel_jack_wire_length = 165;      // Wire length from jack
barrel_jack_nut_depth = 3;          // Depth of mounting nut

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
// ARM SPECIFICATIONS (Straight Arms - arm_straight.scad)
// ----------------------------------------------------------------------------
arm_length = 180;                   // Arm length (parametric: 150-200mm recommended)
arm_width = 12;                     // Arm cross-section width
arm_thickness = 6;                  // Arm cross-section thickness
arm_plug_diameter = 10 - tolerance; // Plug diameter (matches socket)
arm_plug_length = 10;               // Length of plug that goes into hub
arm_hook_diameter = 8;              // Hook inner diameter for hanging elements
arm_hook_thickness = 4;             // Hook wire thickness

// ----------------------------------------------------------------------------
// CURVED ARM SPECIFICATIONS (arm_curved.scad) - DEFAULT
// ----------------------------------------------------------------------------
// Elegant curved arms with integrated hooks for hanging decorations
// Scandinavian-inspired minimalist design

// Main dimensions (inspired by reference: ~56mm x 86mm)
arm_curved_length = 85;             // Length of curved arm
arm_curved_width = 14;              // Width of arm cross-section
arm_curved_height = 8;              // Height/thickness of arm

// Curve shape
arm_curve_arc_height = 12;          // Height of arc peak (creates gentle sweep)
arm_curve_segments = 64;            // Smoothness of curve (higher = smoother)

// Integrated hooks (2 per arm by default)
arm_hook_count = 2;                 // Number of downward-facing hooks
arm_hook_inner_dia = 6;             // Hook opening diameter (for string/ribbon)
arm_hook_wire = 3;                  // Thickness of hook "wire"
arm_hook_depth = 12;                // How far hooks extend downward
arm_hook_opening = 45;              // Opening angle (for easy string attachment)

// Mounting tab (for attachment to hub)
arm_mount_hole_dia = 3.2;           // M3 clearance hole
arm_mount_spacing = 10;             // Distance between mounting holes
arm_mount_length = 18;              // Length of mounting tab
arm_mount_width = 20;               // Width of mounting tab

// Aesthetic channels (decorative grooves)
arm_channel_width = 4;              // Width of recessed channels
arm_channel_depth = 1.5;            // Depth of channels
arm_channel_count = 2;              // Number of parallel channels

// Arm style selection (for assembly.scad)
use_curved_arms = true;             // true = curved arms, false = straight arms

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
motor_mount_vent_count = 4;         // Number of ventilation slots
motor_mount_vent_diameter = 2;      // Ventilation slot diameter

// ----------------------------------------------------------------------------
// ELECTRONICS HOUSING
// ----------------------------------------------------------------------------
// Combined housing for battery, switch, and optional barrel jack
electronics_housing_wall = 3;       // Wall thickness
electronics_housing_corner_r = 5;   // Corner radius
electronics_housing_screw_d = 3;    // M3 mounting screws

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
color_battery = [0.2, 0.2, 0.25];   // Dark charcoal
color_switch = [0.1, 0.1, 0.12];    // Near black
color_electronics = [0.9, 0.9, 0.92]; // Light gray

// ----------------------------------------------------------------------------
// HELPER FUNCTIONS
// ----------------------------------------------------------------------------

// Calculate gear pitch diameter
function pitch_diameter(teeth, mod) = teeth * mod;

// Calculate gear outer diameter  
function outer_diameter(teeth, mod) = (teeth + 2) * mod;

// Calculate center distance between two meshing gears
function center_distance(teeth1, teeth2, mod) = (teeth1 + teeth2) * mod / 2;
