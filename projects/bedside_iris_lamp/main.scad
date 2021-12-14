// "Iris bedside lamp," by skrewz@skrewz.net, is licensed under the Attribution
// - Non-Commercial - Share Alike license.  (c) 2021
//
// Complete license here: http://creativecommons.org/licenses/by-nc-sa/3.0/legalcode
//
// Part overview:
//
// * base(): the thing that clamps onto a mounting point, and that holds
//   electronics. You may need to customise this.
// * lamp_case(): the mount for the ring light and connection to the iris.
// * neck_joint(): https://www.thingiverse.com/thing:824711/files, essentially,
//   and as many as needed.
// * iris(): https://www.thingiverse.com/thing:2796724/files, as per its instructions
//
// Use partname to control which object is being rendered:
//
// _partname_values lamp_case base iris_back_plate iris_front_plate iris_control_plate
partname = "display";

include <libs/compass.scad>
include <libs/esp8266.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 2;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 0.5;

// Likely adjusted:
wall_thickness = 3;
lip_size = 2;
lamp_case_height = 10;
wire_channel_radius = 3;
usb_channel_radius = 4;

bed_column_hd = [25+1,50+2.5];
bed_mount_droop_pipe_radius = 5;


// Less-likely adjusted:
lamp_case_base_radius = 23;
lamp_case_flange_radius = 37.5-wall_thickness;
lamp_case_bolt_supports_radius = 6;
lamp_case_bolt_supports_distance_from_center = lamp_case_flange_radius+9.5;

button_hole_overdimension_factor = 1.15;
// how much to depress (in the z direction) contact_{positive,negative} given
// that the contact point is at z=0.
contact_z_depress = 15;
// how much depression of spring before electrical contact is made:
contact_clearance = 4;

m3_nut_clear_radius = 3.4; // When creating $fn=6 cutouts for m3 nuts


// estimate, for ESP8266:
mcu_cutout_wdh = [60,50,30];

base_front_extension_depth = 15;
base_box_wdh = [
  mcu_cutout_wdh[0]+2*wall_thickness, // arbitrary
  max(base_front_extension_depth+bed_column_hd[1],mcu_cutout_wdh[1]+2*wall_thickness), // large enough for bed_column and mcu
  wall_thickness+mcu_cutout_wdh[2]+wall_thickness+bed_column_hd[0]+wall_thickness
];

// the center of the (male) jointed socket on the base():
base_ball_joint_position = [
  base_box_wdh[0]/2,
  base_front_extension_depth/2,
  base_box_wdh[2]
];

wire_escape_x = base_box_wdh[0]-(5*base_box_wdh[0]/8);


button_positions = [
  [
    base_box_wdh[0]-(1*base_box_wdh[0]/8),
    (base_box_wdh[1]-mcu_cutout_wdh[1])/2,
    base_box_wdh[2],
  ],
  [
    base_box_wdh[0]-(2*base_box_wdh[0]/8),
    (base_box_wdh[1]-mcu_cutout_wdh[1])/2,
    base_box_wdh[2],
  ],
  [
    base_box_wdh[0]-(6*base_box_wdh[0]/8),
    (base_box_wdh[1]-mcu_cutout_wdh[1])/2,
    base_box_wdh[2],
  ],
  [
    base_box_wdh[0]-(7*base_box_wdh[0]/8),
    (base_box_wdh[1]-mcu_cutout_wdh[1])/2,
    base_box_wdh[2],
  ],
];

module contact_negative_buttonbased (depth)
{ // {{{
  fact = button_hole_overdimension_factor;

  // clearance for spikes
  translate([0,-6/2,-depth+5-(2+1-contact_clearance)])
    for (yoff=[0,6-1])
      translate([0,yoff+1/2,-4])
        cylinder(r=1.5,h=depth-5+(2+1-contact_clearance),$fn=20);

  difference()
  {
    translate([-(fact*6)/2,-(fact*6)/2,-depth-(2+1-contact_clearance)])
      cube([fact*6,fact*6,depth+2+(2+1-contact_clearance)+1]);


    translate([-(fact*6)/2,-(fact*6)/2,-4-(2+1-contact_clearance)-3])
      translate([0,((fact*6)-1)/2,0])
      cube([fact*6,1,3]);
  }
} // }}}
module contact_positive_buttonbased ()
{ // {{{
  translate([-6/2,-6/2,-10-(2+1-contact_clearance)])
  {
    minkowski()
    {
      cube([6,6,10+(2+1-contact_clearance)]);
      cylinder(r=2,h=0.001,$fn=20);
    }
  }

  // visualisation
  % union()
  {
    translate([-6/2,-6/2,-4-(2+1-contact_clearance)])
      color("#888888")
      cube([6,6,4]);

    // spikes
    translate([0,-6/2,-4-(2+1-contact_clearance)])
      for (yoff=[0,6-1])
        translate([-1/2,yoff,-4])
          color("#eeeeee")
          cube([1,1,4]);

    translate([-6/2,-6/2,-(2+1-contact_clearance)])
      color("#222222")
      {
        difference()
        {
          cube([6,6,2]);
          for(p=[[0.5,0.5],[0.5,5.5],[5.5,5.5],[5.5,0.5]])
            translate([p[0],p[1],-0.03])
              cylinder(r=1,h=3,$fn=10);
        }
      }

    translate([0,0,-(2+1-contact_clearance)])
      color("red")
      cylinder(r=1.5,h=3,$fn=10);
  }
} // }}}
module neck_joint ()
{ // {{{
  // Best guess, based on STL:
  translate([-9.5,-10.76,-11])
    import("includes/jointed_arm/ball_and_socket_v5_-_main_body.STL");
} // }}}
module neck_joint_final_male ()
{ // {{{
  difference()
  {
    translate([0,0,2])
      mirror([0,0,1])
      neck_joint();
    mirror([0,0,1])
      cylinder(r=20,h=20);
  }
} // }}}
module neck_joint_final_female ()
{ // {{{
  difference()
  {
    neck_joint();
    mirror([0,0,1])
      cylinder(r=20,h=20);
  }
} // }}}

module base ()
{ // {{{
  difference()
  {
    base_pos();
    base_neg();
  }
} // }}}
module base_pos ()
{ // {{{
  cube(base_box_wdh);
  translate(base_ball_joint_position)
    neck_joint_final_male();

  translate([
      base_box_wdh[0]-mcu_cutout_wdh[0],
      base_box_wdh[1]-2*wall_thickness,
      wall_thickness+(mcu_cutout_wdh[2]-esp8266_wdh[0])/2,
  ]) {
    compass();
    rotate([-90,-90,0])
    {
      esp8266_v2();
    }
  }
  // TODO: four silent buttons:
  // * on/off
  // * brightness up
  // * brightness down
  // * mode selector
} // }}}
module base_neg ()
{ // {{{
  // cutout for hooky part to attach to frame
  translate([
      -0.01,
      base_box_wdh[1]-bed_column_hd[1]+0.01,
      base_box_wdh[2]-wall_thickness-bed_column_hd[0]
  ]) {
    cube([
        base_box_wdh[0]+0.02,
        bed_column_hd[1]-wall_thickness,
        bed_column_hd[0]
    ]);
    // cut out lips:
    translate([0,2*wall_thickness,lip_size])
      cube([
          base_box_wdh[0]+0.02,
          bed_column_hd[1]-wall_thickness,
          bed_column_hd[0]-2*lip_size
      ]);
  }

  // cut out wire channel
  translate([
      wire_escape_x,
      base_ball_joint_position[1],
      2*wall_thickness,
  ]){
    cylinder(r=wire_channel_radius,h=2*base_box_wdh[2]);
  }

  // cutout for MCU
  translate([
      (base_box_wdh[0]-mcu_cutout_wdh[0])-wall_thickness,
      wall_thickness,
      wall_thickness
  ]) {
    cube([
        mcu_cutout_wdh[0],
        // ignoring actual mcu_cutout_wdh[1], to allow upwards connectivity:
        base_box_wdh[1]-wall_thickness+0.01,
        mcu_cutout_wdh[2],
    ]);
  }
  // cutout for MCU USB power entry
  translate([
      -0.01,
      wall_thickness+wire_channel_radius,
      wall_thickness+mcu_cutout_wdh[2]/2,
  ]) {
    rotate([0,90,0])
      linear_extrude(height=base_box_wdh[0]-mcu_cutout_wdh[0])
      {
        hull()
        for (yoff = [0+usb_channel_radius+wall_thickness,base_box_wdh[1]-2*(usb_channel_radius+wall_thickness)])
          translate([0,yoff])
            circle(r=usb_channel_radius);
    }
  }

  // cut out for buttons up top
  for (pos = button_positions)
  {
    translate(pos) {
      contact_negative_buttonbased(base_box_wdh[2]-2*wall_thickness);
    }
  }

} // }}}

module lamp_case ()
{ // {{{
  difference()
  {
    lamp_case_pos();
    lamp_case_neg();
  }
} // }}}
module lamp_case_pos ()
{ // {{{
  intersection()
  {
    union()
    {
      // 4 space-age-y cylinders to meet mounting points of iris
      for (i=[0:3])
      {
        lean_angle = 90-atan(
              lamp_case_height
              /
              (
                (lamp_case_bolt_supports_distance_from_center-lamp_case_base_radius)+
                (lamp_case_bolt_supports_radius)
              )
        );
        hull()
        {
          cylinder(r=lamp_case_bolt_supports_radius,h=20*lamp_case_height);
          rotate([0,0,i*90])
          {
            translate([lamp_case_base_radius-lamp_case_bolt_supports_radius,0,0])
            {
              rotate([0,
              lean_angle,
              0])
              {
                cylinder(r=lamp_case_bolt_supports_radius,h=20*lamp_case_height);
              }
            }
          }
        }
      }
    }
    // intersection: a flange-sized cutout and outriggers
    union()
    {
      for (i=[0:3])
      {
        hull()
        {
          cylinder(r=lamp_case_bolt_supports_radius,h=lamp_case_height);
          rotate([0,0,i*90])
          {
            translate([lamp_case_bolt_supports_distance_from_center,0,0])
            {
              cylinder(r=lamp_case_bolt_supports_radius,h=lamp_case_height);
            }
          }
        }
      }
      cylinder(
        r=lamp_case_flange_radius,
        h=lamp_case_height);
    }
  }
  cylinder(
    r1=lamp_case_base_radius+wall_thickness,
    r2=lamp_case_flange_radius,
    h=lamp_case_height);

  translate([0,0,0])
    mirror([0,0,1])
      neck_joint_final_female();
} // }}}

module lamp_case_neg ()
{ // {{{
  // cut off from top at flange:
  translate([0,0,lamp_case_height])
  {
    cylinder(
      r=2*lamp_case_flange_radius,
      h=2*lamp_case_height);
  }
  // wire exit towards jointed arm:
  translate([-(lamp_case_base_radius-lamp_case_bolt_supports_radius),0,-0.01])
  {
    cylinder(r=wire_channel_radius, h=3*wall_thickness);
  }
  // cut out the hole above the lights:
  translate([0,0,wall_thickness])
  {
    cylinder(
      r=lamp_case_base_radius,
      h=lamp_case_height+0.02);
  }
  // nut holes for fastening the iris:
  for (i=[0:3])
  {
    rotate([0,0,i*90])
    {
      translate([lamp_case_bolt_supports_distance_from_center,0,lamp_case_height])
      {
        mirror([0,0,1])
        {
          translate([0,0,-0.01])
          {
            cylinder(r=1.6,h=lamp_case_height);
            translate([0,0,3])
              cylinder(r=m3_nut_clear_radius,h=lamp_case_height,$fn=6);
          }
        }
      }
    }
  }
} // }}}

module iris_assembly ()
{ // {{{
  import("includes/iris/Back_Plate.stl");
  translate([0,0,3.5])
    import("includes/iris/Control_Plate.stl");
  translate([0,0,12])
    mirror([0,0,1])
    import("includes/iris/Front_Plate.stl");

} // }}}




// Conventions:
// * When an object is rendered using partname, position/rotate it according to
//   printing suggestion, here. (The module itself will be positioned/rotated
//   like it will be, in the put-together "display" situation.)
// * The special value "display" for partname is the product picture for all
//   parts put together.

if ("display" == partname)
{
  base();
  translate([base_box_wdh[0]/2,-30,1.5*base_box_wdh[2]])
  {
    rotate([90,0,0])
      lamp_case();
    translate([0,-lamp_case_height,0])
      rotate([90,0,0])
        iris_assembly();
  }
} else if ("lamp_case" == partname)
{
  rotate([180,0,0])
    lamp_case();
} else if ("base" == partname)
{
  rotate([0,-90,0])
    base();
} else if ("iris_back_plate" == partname)
{
  import("includes/iris/Back_Plate.stl");
} else if ("iris_front_plate" == partname)
{
  import("includes/iris/Front_Plate.stl");
} else if ("iris_control_plate" == partname)
{
  import("includes/iris/Control_Plate.stl");
}
