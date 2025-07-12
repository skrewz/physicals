// Use partname to control which object is being rendered:
//
// _partname_values middle_section base
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;


// The radius of the curtain rod in use:
curtain_rod_r = 32/2;

// The angle at which the rods lean:
rod_angle = 10;

num_rods = 3;

// The eventual height of the riser:
desired_riser_height = 900;

rod_offset = 1.2*curtain_rod_r;
base_overall_height = 20;
base_solid_height = 2;
base_oversizing = 1.05;
middle_section_oversizing = 1.1;
middle_section_height = 4*curtain_rod_r;


// Calculated parameters:
// Note that we're componsating for the rod being straight-cut at the end (like
// an OpenSCAD cylinder()) and as such sits on a point on its periphery
rod_length = (desired_riser_height-2*base_solid_height)/cos(rod_angle)-2*sin(rod_angle)*curtain_rod_r;
echo ("rod_length:", rod_length);

module base()
{
  difference()
  {
    translate([0,0,base_solid_height])
    {
      hull()
      {
        scale([base_oversizing,base_oversizing,1])
        {
          hull()
          {
            intersection()
            {
              rods_setup_lifted(2*rod_length);
              translate([0,0,-base_solid_height])
              {
                cylinder(r=desired_riser_height,h=base_overall_height);
              }
            }
          }
        }
      }
    }
    rods_setup_lifted(rod_length);
  }
}

module middle_section()
{
  difference()
  {
    scale([middle_section_oversizing,middle_section_oversizing,1])
    {
      hull()
      {
        intersection()
        {
          rods_setup();
          translate([0,0,-middle_section_height/2])
          {
            cylinder(r=desired_riser_height, h=middle_section_height);
          }
        }
      }
    }
    rods_setup();
  }
}

module rods_setup_lifted(length = rod_length)
{
  translate([0,0,desired_riser_height/2])
  {
    rods_setup(length);
  }
}
module rods_setup(length = rod_length)
{
  for(i=[0:num_rods-1])
  {
    rotate([0,0,i*(360/num_rods)])
    {
      translate([rod_offset,0,0])
      {
        rotate([rod_angle,0,0])
        {
          translate([0,0,-length/2])
          {
            cylinder(r=curtain_rod_r, h=length);
          }
        }
      }
    }
  }
}
module rods_visualisation()
{
  rods_setup_lifted();
}


// Conventions:
// * When an object is rendered using partname, position/rotate it according to
//   printing suggestion, here. (The module itself will be positioned/rotated
//   like it will be, in the put-together "display" situation.)
// * The special value "display" for partname is the product picture for all
//   parts put together.
if ("display" == partname)
{
  base();
  color("grey")
  {
    rods_visualisation();
  }
  translate([0,0,desired_riser_height/2])
  {
    middle_section();
  }
  /*
     translate([0,0,desired_riser_height+2*base_overall_height])
     {
     mirror([0,0,1])
     {
     base();
     }
     }
   */


} else if ("base" == partname)
{
  base();
} else if ("middle_section" == partname)
{
  middle_section();
}
