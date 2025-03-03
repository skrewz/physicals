// Use partname to control which object is being rendered:
//
// _partname_values clasp hook
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

wall_w = 3;
panel_width_cutout = 3.0+0.1;
clasp_width = 150;
clasp_height = 20;

throughhole_r = 4/2;
hook_r = 6;
hook_cutout_r = 6+0.5;
hook_cutout_d = 1.1*(2*wall_w + panel_width_cutout);
hook_height = clasp_height + hook_cutout_r;

hook_mounting_plate_wd = [40,40];
hook_mounting_plate_offset = 10;



hook_eye_offset = hook_cutout_r+wall_w;

module clasp()
{
  difference()
  {
    union()
    {
      cube([clasp_width, 2*wall_w+panel_width_cutout, clasp_height]);
      translate([clasp_width/2,0,hook_height+hook_eye_offset])
      {
        rotate([-90,0,0])
        {
          hull()
          {
            cylinder(r=hook_cutout_r+wall_w, h=2*wall_w+panel_width_cutout);
            translate([0,hook_height,0])
            {
              cylinder(r=hook_cutout_r+wall_w, h=2*wall_w+panel_width_cutout);
            }
          }
        }
      }
    }
    translate([-0.01,wall_w,-0.01])
    {
      cube([clasp_width+0.02, panel_width_cutout, clasp_height-wall_w]);
    }

    // The throughhole's for mounting the perspex:
    cover_distance = clasp_width - 2*wall_w - 2*throughhole_r;
    for (offset = [wall_w+throughhole_r:cover_distance/3:clasp_width-wall_w-throughhole_r]) {
      translate([offset,-0.01,(clasp_height-wall_w)/2])
      {
        rotate([-90,0,0])
        {
          cylinder(r=throughhole_r, h=2*wall_w+panel_width_cutout+0.02);
        }
      }
    }
    // The hook hole:
    translate([clasp_width/2,-0.01,hook_height])
    {
      rotate([-90,0,0])
      {
        hull()
        {
          cylinder(r=hook_cutout_r, h=2*wall_w+panel_width_cutout+0.02);
          translate([0,-hook_eye_offset,0])
          {
            cylinder(r=hook_cutout_r, h=2*wall_w+panel_width_cutout+0.02);
          }
        }
      }
    }
  }
}

module hook()
{
  hull()
  {
    // The mounting plate in its position:
    translate([-hook_mounting_plate_wd[0]/2,-hook_mounting_plate_wd[1],hook_mounting_plate_offset])
    {
      cube([hook_mounting_plate_wd[0],hook_mounting_plate_wd[1],wall_w]);
    }
    // A piece to anchor the hull() onto the outrigger:
    rotate([-90,0,0])
    {
      cylinder(r=hook_r, h=0.01);
    }
  }

  // The outrigger hook_r-based hook:
  rotate([-90,0,0])
  {
    cylinder(r=hook_r, h=hook_cutout_d);
    hull()
    {
      for (yoff = [0,-hook_r/2] )
      {
        translate([0,yoff,hook_cutout_d])
        {
          cylinder(r=hook_r, h=wall_w);
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
  clasp();
  translate([clasp_width/2,-(0.05*hook_cutout_d),hook_height+hook_eye_offset])
  {
    hook();
  }
} else if ("clasp" == partname)
{
  clasp();
} else if ("hook" == partname)
{
  rotate([180,0,0])
  {
    hook();
  }
}
