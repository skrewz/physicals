// Use partname to control which object is being rendered:
//
// _partname_values clip
partname = "display";

// Size of ledge to hold on to: ~15mm wide
ledge_width = 14;
// how far out to stretch the rounded part:
bend_length = 20;
// how high above the base does the ledge go?
ledge_height = 7;
// how much wall thickness should the ledged part have?
ledge_part_thickness = 2;
// Cable diameter around 4mm
cable_r = 2.3;
// Clip width, to fit (and conceal) 9mm double-adhesive tape:
clip_width = 14;

// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 2;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 1;

module clip()
{
  difference()
  {
    scale([1.0,(ledge_height+ledge_part_thickness)/bend_length,1.0])
      cylinder(r=bend_length,h=clip_width);
    // cut out bottom:
    translate([-bend_length,-bend_length,-clip_width])
      cube([2*bend_length,bend_length,3*clip_width]);
    // cut out left side:
    translate([-bend_length,-bend_length,-clip_width])
      cube([bend_length,3*bend_length,3*clip_width]);
    // cut out cable channel:
    translate([-0.01,-0.01,-clip_width])
      cube([3*cable_r,2*cable_r,3*clip_width]);
  }
  // add ledge:
  translate([-ledge_width,ledge_height,0])
    cube([ledge_width,ledge_part_thickness,clip_width]);
}


// Conventions:
// * When an object is rendered using partname, position/rotate it according to
//   printing suggestion, here. (The module itself will be positioned/rotated
//   like it will be, in the put-together "display" situation.)
// * The special value "display" for partname is the product picture for all
//   parts put together.
if ("display" == partname)
{
  clip();
} else if ("clip" == partname)
{
  clip();
}
