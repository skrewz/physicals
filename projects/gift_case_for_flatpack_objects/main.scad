// Use partname to control which object is being rendered:
//
// _partname_values mold
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 12;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;


// Kangaroo item:
// mold_wdh = [100,105,6];
// cutout_bounding_box = [93.5+2,100.2+5,3.75+0.25];

// Koala item:
mold_wdh = [115,105,6];
cutout_bounding_box = [106,97,3.75+0.25];

rounding_r = 2;

module mold()
{
  difference()
  {
    minkowski()
    {
      sphere(r=rounding_r,$fn=30);
      translate([rounding_r,rounding_r,rounding_r])
        cube (mold_wdh-[2*rounding_r,2*rounding_r,2*rounding_r]);
    }
    translate([
      (mold_wdh[0]-cutout_bounding_box[0])/2,
      (mold_wdh[1]-cutout_bounding_box[1])/2,
      (mold_wdh[2]-cutout_bounding_box[2])
    ]) {
      /* cube (cutout_bounding_box); */
      resize(cutout_bounding_box+[0,0,1])
      {
        surface(file="cutout.png");
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
  mold();
} else if ("mold" == partname)
{
  rotate([0,0,0])
  {
    mold();
  }
}
