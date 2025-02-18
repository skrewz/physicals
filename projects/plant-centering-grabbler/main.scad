// Use partname to control which object is being rendered:
//
// _partname_values clasp
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 6 : 2;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

wall_w = 2;

// Outer radius of vase to mount onto:
// (Might be easiest to measure as circumference and do the math here.)
vase_cutout_r = (470/3.1415)/2+0.5; // measured circumference: 47.0cm
vase_clasp_height = 15;
vase_clasp_rim_width = 4;

num_clasps = 8;
clasp_rl = [3,1.2*vase_clasp_height];
clasp_angle = 45;

module clasp()
{
  difference()
  {
    union()
    {
      for (r=[0:num_clasps])
      {
        rotate([0,0,r*(360/num_clasps)])
        {
          translate([vase_cutout_r-clasp_rl[0],0,vase_clasp_height])
          {
            rotate([0,180-clasp_angle,0])
            {
              cylinder(r=clasp_rl[0], h=clasp_rl[1]);
            }
          }
        }
      }
      cylinder(r=vase_cutout_r+wall_w, h=vase_clasp_height+wall_w);

    }
    // The vase cutout:
    translate([0,0,-0.01])
    {
      cylinder(r=vase_cutout_r, h=vase_clasp_height+0.02);
    }
    // The centre rim cutout
    translate([0,0,vase_clasp_height-0.01])
    {
      cylinder(r=vase_cutout_r-vase_clasp_rim_width, h=wall_w+0.02);
    }
    // Trimming off any pegs coming off the clasps:
    translate([0,0,vase_clasp_height+wall_w])
    {
      cylinder(r=vase_cutout_r+wall_w, h=vase_clasp_height+wall_w);
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
  clasp();
} else if ("clasp" == partname)
{
  rotate([180,0,0])
  {
    clasp();
  }
}
