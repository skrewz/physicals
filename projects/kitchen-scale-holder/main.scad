// Use partname to control which object is being rendered:
//
// _partname_values holder
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 12;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 0.5;


module holder()
{
  difference()
  {
    cube([20,25,70]);
    hull()
    {
      for(zoff = [10,70])
        translate([-10,12.5,zoff])
        rotate([0,90,0])
        cylinder(r=6,h=50);
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
  holder();
} else if ("holder" == partname)
{
  rotate([0,-90,0])
  {
    holder();
  }
}
