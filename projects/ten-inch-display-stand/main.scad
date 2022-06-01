// (C) Anders Breindahl <skrewz@skrewz.net>, 20150601. License: GPL3+.
//
// Use partname to control which object is being rendered:
//
// _partname_values right_side_of_case left_side_of_case
partname = "display";

// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 10;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 0.1;

create_button_board_button_with_inner_radius = 2.5;

// Mesaurements of the hardware that this wraps:
/* controller_board_width             = 91; */
/* controller_board_depth             = 65; */
/* controller_board_pcb_thickness     = 1.5; // imprecise */
/* controller_board_pcb_height_offset = 2.5; // imprecise */
/* controller_board_gross_height      = 17; // imprecise */

osd_board_wdh=[108,15,15];
osd_board_wdh_clearance=[osd_board_wdh[0]+10,osd_board_wdh[1]+1,osd_board_wdh[2]];
disp_cont_board_wdh = [110,56,10];
disp_cont_board_clear_wdh = [110,56+75,25];
disp_cont_board_bottom_offset = 2.5; // imprecise */
disp_cont_board_hdmi_inset = 26; // to centre of plug

button_board_width                        = 76;
button_board_button_offsets               = [ 5, 24, 40, 53, 71 ];
button_board_pcb_thickness                = 1.5; // imprecise
button_board_pcb_height_offset            = 5;
button_board_button_center_pcb_inset      = 5;
button_board_depth                        = 20; // TODO: Guesstimated!
button_board_relative_connector_placement = [ 42,button_board_depth,0];

// https://www.aliexpress.com/item/4000358029140.html:  229.75 × 151.22 × 4.61 mm (H × V × D)
display_wdh = [231,152,4];
case_height = 27;
case_lean_angle = 60;
case_feet_length = 70;
case_feet_width = 20;
grab_thickness = 1;
grab_radius = 10;
ridge_inset = 3;
ridge_thickness = 3;

hdmi_plug_clear_wh = [22,12];
hdmi_plug_clear_plug_length = 50;

corner_r = 3;
wall_w = 2;
board_indent_depth = 3.8;

cutout_x_offset = 100;
cutout_width = 30;
cutout_access_width = 40;

module holder ()
{
  rotate([0,90,0])
  {
    intersection()
    {
      cylinder(r1=9,r2=0,h=30);
      translate([-10,0,0])
        cube([20,20,30]);
    }
  }
}
module nutholder ()
{
  difference()
  {
    holder();
    translate([-0.01,4,0])
      rotate([0,90,0])
        cylinder(r=1.7,h=7);
    translate([5,1,-5])
      cube([3,10,10]);
  }
}
module boltholder ()
{
  difference()
  {
    holder();
    translate([-0.01,4,0])
    {
      rotate([0,90,0])
        cylinder(r=1.7,h=30);
      translate([5,0,0])
        rotate([0,90,0])
          cylinder(r=4,h=30);
    }
  }
}
module nutboltholderpair ()
{
  nutholder();
  mirror([1,0,0])
    boltholder();
}

module ridgehelper(w,d,inset_top,inset_bottom,outer_thickness,added_inset=0)
{
  difference()
  {
    cube([
        w,
        d,
        outer_thickness-0.02
    ]);
    translate([0,0,-0.01])
      minkowski()
      {
        cylinder(r1=inset_top,r2=inset_bottom,h=outer_thickness);
        translate([inset_top+added_inset,inset_top+added_inset,0])
          cube([
              w-2*inset_top-2*added_inset,
              d-2*inset_top-2*added_inset,
              0.01
          ]);
      }
  }
}

module bare_case ()
{
  translate([corner_r,corner_r,0])
  {
    difference()
    {
      minkowski()
      {
        cube([
            display_wdh[0],
            display_wdh[1],
            case_height-corner_r
        ]);
        //cylinder(r=corner_r,h=1);
        sphere(r=corner_r);
      }
      translate([-100,-100,-100])
        cube([400,300,100]);
      translate([0,0,wall_w+board_indent_depth])
        cube([display_wdh[0],display_wdh[1],100]);
    }
    // Grab corners of display:
    translate([0,0,case_height-grab_thickness])
    {
      ridgehelper(display_wdh[0],display_wdh[1],grab_radius,grab_radius,grab_thickness,2);
    }
    // Create ledge for display to sit on:
    translate([0,0,case_height-display_wdh[2]-grab_thickness-ridge_thickness])
    {
      ridgehelper(display_wdh[0],display_wdh[1],ridge_inset,0,ridge_thickness);
    }
  }
}

module whole_case ()
{
  module foot()
  {
    // Adding feet for case to lean:
    translate([corner_r,corner_r,0])
      minkowski()
      {
        union()
        {
          rotate([-case_lean_angle,0,0])
            cube([case_feet_width-2*corner_r,case_feet_length,0.01]);
          translate([
              0,
              case_feet_length*sin(90-case_lean_angle),
              -case_feet_length*cos(90-case_lean_angle)
          ])
            cube([case_feet_width-2*corner_r,0.01,case_feet_length*cos(90-case_lean_angle)]);
        }
        sphere(r=corner_r);
      }
  }

  difference()
  {
    union ()
    {
      /*
         translate([corner_r+wall_w,corner_r+wall_w,case_height-display_wdh[2]-grab_thickness])
         %
         display();
         */

      difference()
      {
        union()
        {
          bare_case();

          // Adding bolt / nutholder pairs on either side:
          translate([cutout_x_offset+cutout_width,0,0.45*case_height])
          {
            translate([0,corner_r,0])
              nutboltholderpair();
            translate([0,display_wdh[1]+corner_r,0])
              mirror([0,1,0])
                nutboltholderpair();
          }

          for(xoff=[0,display_wdh[0]+2*corner_r-case_feet_width])
            translate([xoff,0,0])
              foot();

        }

        // HDMI cable exit hole

        translate([
            display_wdh[0]+corner_r+2*corner_r,
            corner_r,
            /* (display_wdh[1]+2*corner_r)/2-hdmi_plug_clear_wh[0]/2, */
            wall_w+board_indent_depth]) {
            rotate([0,-90,0])
            {
              translate([2,2,0])
              minkowski()
              {
                cylinder(r=2,h=4*corner_r);
                cube([hdmi_plug_clear_wh[1]-2,hdmi_plug_clear_wh[0]-2,0.01]);
              }
            }
        }
        translate([corner_r+wall_w,corner_r+wall_w,wall_w+board_indent_depth])
        {

          translate([0,disp_cont_board_wdh[0]+wall_w+10 /*TODO: better calculation here*/,-board_indent_depth])
          {
            rotate([0,0,-90])
            cube(disp_cont_board_wdh);
            translate([disp_cont_board_wdh[1]-0.01,-(disp_cont_board_wdh[0]-disp_cont_board_hdmi_inset),0])
              cube([hdmi_plug_clear_plug_length,hdmi_plug_clear_wh[0],disp_cont_board_wdh[2]]);
          }

        }
        // The middle cutouts to access nuts and bolts etc
        for (yoff=[corner_r,display_wdh[1]+corner_r-cutout_access_width])
        translate([cutout_x_offset,yoff,-0.01])
          cube([cutout_width,cutout_access_width,1.01*(wall_w+board_indent_depth)]);
      }
    }
  }
}



module render_hardware(hardware_name)
{
  if ("display" == hardware_name)
    %
    color("grey")
      cube (display_wdh);
  else if ("controller_board" == hardware_name)
  {
    color("green")
    {
      translate([0,0,disp_cont_board_bottom_offset])
      {
        cube (disp_cont_board_wdh);
        %
        cube (disp_cont_board_clear_wdh);
      }
    }
  }
  else if ("button_board" == hardware_name)
  {
    translate([0,0,button_board_pcb_height_offset])
      color("black")
      cube ([button_board_width,button_board_depth,button_board_pcb_thickness]);
    translate([0,0,button_board_pcb_height_offset+button_board_pcb_thickness])
    {
      translate (button_board_relative_connector_placement)
      {
        color("grey")
          cube ([22,5,5]); // TODO: Guesstimated!
      }
      for (button_offset = button_board_button_offsets)
        translate ([button_offset,button_board_button_center_pcb_inset,0])
        {
          translate([-2,-2,0])
            color("black")
            cube ([4,4,2]);
          translate([0,0,2])
            color("red")
            cylinder (r=1.5,h=1);
        }
    }
  }
}

module left_side_of_case ()
{
  intersection()
  {
    whole_case();
    translate([0,0,-100])
      cube([cutout_x_offset+cutout_width,200,200]);
  }
}


module right_side_of_case()
{
  translate([10,0,0])
  {
    intersection()
    {
      whole_case();
      translate([cutout_x_offset+cutout_width,0,-100])
        cube([200,200,200]);
    }
  }
}


// Conventions:
// * When an object is rendered using partname, position/rotate it according to
//   printing suggestion, here. (The module itself will be positioned/rotated
//   like it will be, in the put-together "display" situation.)
// * The special value "display" for partname is the product picture for all
//   parts put together.
if ("display" == partname)
{
  rotate([case_lean_angle,0,0])
  {
    left_side_of_case();
    right_side_of_case();
  }

} else if ("right_side_of_case" == partname)
{
  rotate([0,90,0])
    right_side_of_case();
} else if ("left_side_of_case" == partname)
{
  rotate([0,-90,0])
  left_side_of_case();
}
