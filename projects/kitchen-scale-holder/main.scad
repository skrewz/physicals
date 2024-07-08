// Use partname to control which object is being rendered:
//
// _partname_values holder
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

scale_cutout = 21;
wall_w = 5;

holder_wh = [30,90];

module holder()
{
  difference()
  {
    cube([holder_wh[0],scale_cutout+2*wall_w,holder_wh[1]]);
    hull()
    {
      for(zoff = [scale_cutout/2+wall_w,holder_wh[1]])
        translate([-wall_w,wall_w+scale_cutout/2,zoff])
        rotate([0,90,0])
        cylinder(r=scale_cutout/2,h=2*wall_w+holder_wh[0]);
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
