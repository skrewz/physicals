// Use partname to control which object is being rendered:
//
// _partname_values unit_circle
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 12;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;


module unit_circle()
{
  sphere(r=1);
}


// Conventions:
// * When an object is rendered using partname, position/rotate it according to
//   printing suggestion, here. (The module itself will be positioned/rotated
//   like it will be, in the put-together "display" situation.)
// * The special value "display" for partname is the product picture for all
//   parts put together.
if ("display" == partname)
{
  translate([0,0,10])
  {
    unit_circle();
  }
} else if ("unit_circle" == partname)
{
  rotate([0,0,0])
  {
    unit_circle();
  }
}
