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


dock_actual_wdh = [100,100,30];
dock_cutout_wdh = [105,105,40];

wall_w = 3;
holder_width = 20;
flange_extra_dim = 20;

module holder()
{
  across_dim = sqrt(pow(dock_cutout_wdh[0]+2*wall_w,2)+pow(dock_cutout_wdh[1]+2*wall_w,2));
  intersection()
  {
    difference()
    {
      hull()
      {
        cube(dock_cutout_wdh+[2*wall_w,2*wall_w,wall_w]);
        // add the flange for double-adhesive tape or screws:
        translate([-flange_extra_dim,-flange_extra_dim,dock_cutout_wdh[2]])
        {
          cube([dock_cutout_wdh[0]+2*wall_w+2*flange_extra_dim,dock_cutout_wdh[1]+2*wall_w+2*flange_extra_dim,wall_w]);
        }
      }
      translate([wall_w,wall_w,wall_w+0.01])
      {
        cube(dock_cutout_wdh+[flange_extra_dim,0,0]);
      }
    }
    union()
    {
      translate([wall_w+dock_cutout_wdh[0]/2,wall_w+dock_cutout_wdh[1]/2,0])
      {
        for (zrot = [-45,45])
        {
          rotate([0,0,zrot])
          {
            translate([-holder_width/2,-across_dim/2-flange_extra_dim,0])
            {
              cube([holder_width,across_dim+2*flange_extra_dim,dock_cutout_wdh[2]+wall_w]);
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
  holder();
} else if ("holder" == partname)
{
  rotate([0,0,0])
  {
    holder();
  }
}
