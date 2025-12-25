// Use partname to control which object is being rendered:
//
// _partname_values safety_piece
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;


wall_w = 1.5;

safety_piece_length = 450;
safety_piece_middle_cutout_wd = [15.2,10];

module safety_piece()
{
  cylinder_offset = max(safety_piece_middle_cutout_wd[0]/2+wall_w, safety_piece_middle_cutout_wd[1]);
  difference()
  {
    union()
    {
      translate([0,0,cylinder_offset])
      {
        rotate([0,90,0])
        {
          cylinder(r=(safety_piece_middle_cutout_wd[0]/2+wall_w), h=safety_piece_length);
        }
      }
      translate([0,-(safety_piece_middle_cutout_wd[0]+2*wall_w)/2,0])
      {
        cube([safety_piece_length,safety_piece_middle_cutout_wd[0]+2*wall_w,cylinder_offset]);
      }
    }
    translate([-0.01,-safety_piece_middle_cutout_wd[0]/2,-0.01])
    {
      cube([safety_piece_length+0.02,safety_piece_middle_cutout_wd[0],safety_piece_middle_cutout_wd[1]]);
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
  safety_piece();
} else if ("safety_piece" == partname)
{
  safety_piece();
}
