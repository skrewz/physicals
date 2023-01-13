// Use partname to control which object is being rendered:
//
// _partname_values case
partname = "display";

include <libs/compass.scad>
include <libs/rounded_cube.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 12;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

rounding = 3;

module case()
{
  difference()
  {
    translate([-rounding,0,0])
      rounded_cube([rounding+77,rounding+69,rounding+22.5], rounding);
    union()
    {
      translate([-rounding,rounding/2,rounding/2])
        rounded_cube([77,69,22.5],0.9*rounding);
      mirror([1,0,0])
        cube([rounding,69+2*rounding,22.5+2*rounding]);
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
  case();
} else if ("case" == partname)
{
  case();
}
