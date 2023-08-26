// Use partname to control which object is being rendered:
//
// _partname_values mount
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

wall_w = 2;
angle = 60;
length = 40;

width = 30;

module mount()
{
  difference()
  {
    union()
    {
      cube([width,length,wall_w]);
      rotate([angle,0,0])
      {
        cube([width,length/cos(angle),wall_w]);
      }
      translate([(width-wall_w)/2,0,0])
      {
        cube([wall_w,length,length/cos(angle)]);
      }
    }
    rotate([angle,0,0])
    {
      translate([0,0,wall_w])
      {
        cube([width,2*length/cos(angle),length]);
      }
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
  mount();
} else if ("mount" == partname)
{
  rotate([0,90,0])
  {
    mount();
  }
}
