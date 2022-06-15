// Use partname to control which object is being rendered:
//
// _partname_values clamp
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 5;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 1;

wall_width = 3;

column_wd = [50, 70];
clamp_hd = [30,40];
bump_height = 2;
bump_radius = 10;
// the depth of the tee is the air gap under its upper bar:
H_wd = [110,3];

// along column_wd[0], how far from 0 is the middle between two curtains? (i.e. where to center the H):
centerline_offset = 20;


module clamp ()
{
  // the clamp part:
  difference()
  {
    cube([column_wd[0]+2*wall_width,clamp_hd[1],clamp_hd[0]]);
    translate([wall_width,wall_width,-0.01])
    {
      difference()
      {
        cube([column_wd[0],column_wd[1],clamp_hd[0]+0.02]);
        for(xoff = [-bump_radius+bump_height, column_wd[0]+bump_radius-bump_height])
          for(yoff = [1*clamp_hd[1]/2])
            for(zoff = [bump_radius, clamp_hd[0]-bump_radius])
              translate([xoff, yoff, zoff])
                sphere(r=bump_radius);
      }
    }
  }
  
  // the H:
  
  translate([centerline_offset-wall_width/2-H_wd[0]/2,0,0])
    cube([H_wd[0],wall_width,clamp_hd[0]]);
  translate([centerline_offset-wall_width/2,-H_wd[1],0])
  {
    cube([2*wall_width,H_wd[1],clamp_hd[0]]);
    translate([-H_wd[0]/2,-wall_width,0])
      cube([H_wd[0],wall_width,clamp_hd[0]]);
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
  clamp ();
} else if ("clamp" == partname)
{
  rotate([0,0,0])
  {
    clamp ();
  }
}
