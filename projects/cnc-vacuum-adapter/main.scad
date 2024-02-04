// Use partname to control which object is being rendered:
//
// _partname_values funnel
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

wall_w = 2;
hose_r = 42 / 2;
hose_attachment_length = 45;

er11_nut_r = 19/2;
er11_nut_clearance = 2;

double_adhesive_tape_thickness = 1;

// collet_v_duct_offset controls where the spindle cutthrough is made,
// relative to the [x,y,z] of the last ring (the Z coordinate isn't very useful).
//
// (This moves the last ring cutout and keeps the spindle in place.)
collet_v_duct_offset = [0,10,0];

// The sequence of rings that define the duct's trajectory.
//
// These are tuples of [[x,y,z],[xrot,yrot,zrot],radius].
function rings(base_radius) = [
  [
    [0,0,0],
    [0,0,0],
    base_radius
  ],
  [
    [5,0,-10],
    [0,-22.5,0],
    base_radius
  ],
  [
    [15,0,-17],
    [0,-40,0],
    base_radius
  ],
  [
    [30,0,-22],
    [0,-45,0],
    base_radius
  ],
  [
    [55,0,-32],
    [0,-30,0],
    base_radius
  ],
  [
    [61,-21,-44]+collet_v_duct_offset,
    [0,0,0],
    // tip: consider playing with aa quite large value here to provide a lot of
    // pickup area (but also bear suction force in mind):
    base_radius
  ],
];


module display_cnc_mill_head()
{
  translate([0,-67,0])
  {
    color("grey")
    {
      cube([75,67,47]);
    }
  }
  translate([75/2,-67,0])
  {
    color("grey")
    {
      cylinder(r=75/2,h=47);
    }
  }
  translate([75/2,-67,-50])
  {
    color("grey")
    {
      difference()
      {
        cylinder(r=16/2,h=50);
        // not actually sure how deep these cuts go. Oh well?
        for (xoff = [-16-16/2+1.5,16/2-1.5])
        {
          translate([xoff,-16/2,12+13])
          {
            cube([16,16,8]);
          }
        }
      }
    }
    color("#333333")
    {
      translate([0,0,-0.01])
      {
        cylinder(r=er11_nut_r,h=6,$fn=6);
      }
      translate([0,0,6])
      {
        cylinder(r=er11_nut_r,h=6);
      }
    }
  }
}

module funnel()
{
  module duct(base_radius)
  {
    rings = rings(base_radius);
    module duct_helper(extra_radius,extra_offset)
    {
      for (i = [0:len(rings)-1-1])
      {
        hull()
        {
          translate(rings[i][0]+[0,0,extra_offset])
          {
            rotate(rings[i][1])
            {
              cylinder(r=rings[i][2]+extra_radius, h=0.01);
            }
          }
          translate(rings[i+1][0]-[0,0,extra_offset])
          {
            rotate(rings[i+1][1])
            {
              cylinder(r=rings[i+1][2]+extra_radius, h=0.01);
            }
          }
        }
      }
    }

    // main ER11 clearance
    difference()
    {
      union()
      {
        // Hose holder:
        difference()
        {
          union()
          {
            translate([0,-(hose_r+wall_w),0])
            {
              cube([hose_r+wall_w,2*(hose_r+wall_w),hose_attachment_length]);
            }
            cylinder(r=hose_r+wall_w, h=hose_attachment_length);
          }
          translate([0,0,-0.02])
          {
            cylinder(r=hose_r, h=hose_attachment_length+0.1);
          }
        }
        // Channel for ER11 to fit through:
        intersection()
        {
          duct_helper(0,0);
          translate(rings[len(rings)-1][0]-collet_v_duct_offset)
          {
            hull ()
            {
              for (yoff = [0,-max(2*(er11_nut_r+er11_nut_clearance),rings[len(rings)-1][2])])
              {
                translate([0,yoff,0])
                {
                  cylinder(r=er11_nut_r+er11_nut_clearance+wall_w, h=50);
                }
              }
            }
          }
        }
        difference()
        {
          union()
          {
            duct_helper(wall_w,0);
          }
          duct_helper(0,0.02);

        }
      }
      translate(rings[len(rings)-1][0]-collet_v_duct_offset-[0,0,0.1])
      {
        hull ()
        {
          for (yoff = [0,-max(2*(er11_nut_r+er11_nut_clearance),rings[len(rings)-1][2])])
          {
            translate([0,yoff,0])
            {
              cylinder(r=er11_nut_r+er11_nut_clearance, h=50);
            }
          }
        }
      }
    }
  }

  duct(hose_r);
}


// Conventions:
// * When an object is rendered using partname, position/rotate it according to
//   printing suggestion, here. (The module itself will be positioned/rotated
//   like it will be, in the put-together "display" situation.)
// * The special value "display" for partname is the product picture for all
//   parts put together.
if ("display" == partname)
{
  translate([hose_r+wall_w+double_adhesive_tape_thickness,43,0])
  {
    % display_cnc_mill_head();
  }
  funnel();
} else if ("funnel" == partname)
{
  rotate([180,0,0])
  {
    funnel();
  }
}
