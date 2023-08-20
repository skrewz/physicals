// Use partname to control which object is being rendered:
//
// _partname_values attachment
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

wall_w = 2;
// outer radius here:
attachment_rh = [15.75,35];
hose_cutout_r = 43/2;
hose_attachment_rh = [hose_cutout_r+wall_w,40];

cable_tie_cutout_w = 3.5;
cable_tie_indent = 4;


module attachment()
{
  difference()
  {
    union()
    {
      cylinder(r=hose_attachment_rh[0],h=hose_attachment_rh[1]);
      translate([-(hose_attachment_rh[0]-attachment_rh[0]),0,hose_attachment_rh[1]])
      {
        cylinder(r=attachment_rh[0],h=attachment_rh[1]);
      }
    }
    union()
    {
      translate([0,0,-0.01])
      {
        cylinder(r=hose_attachment_rh[0]-wall_w,h=hose_attachment_rh[1]-wall_w+0.02);
      }
      translate([-(hose_attachment_rh[0]-attachment_rh[0]),0,hose_attachment_rh[1]-wall_w-0.01])
      {
        cylinder(r=attachment_rh[0]-wall_w,h=attachment_rh[1]+wall_w+0.02);
      }
      // Cutouts to mount a cable tie onto the hose through:
      for (rot = [0,180])
      {
        rotate([0,0,rot])
        {
          for (zoff = [0.25*hose_attachment_rh[1]-cable_tie_cutout_w/2, 0.75*hose_attachment_rh[1]-cable_tie_cutout_w/2])
          {
            translate([hose_attachment_rh[0]-wall_w-cable_tie_indent,0,zoff])
            {
              translate([0,-hose_attachment_rh[0],0]){
                cube([hose_attachment_rh[0],2*hose_attachment_rh[0],cable_tie_cutout_w]);
              }
            }
          }
        }
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
  translate([0,0,10])
  {
    attachment();
  }
} else if ("attachment" == partname)
{
  rotate([0,0,0])
  {
    attachment();
  }
}
