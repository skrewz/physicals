// Use partname to control which object is being rendered:
//
// _partname_values holder
partname = "holder";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 3;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 2;

// How wide and tall is the clasp that this fits around?
gap_for_clasp_wh = [11,16];

// How tall and how large radius is used to hold the chain?
clasp_height_off_wall = 40;
clasp_rounding_r = 10;

// For the rounded part, how wide should the part be? (This largely depends on
// the size of the balls on chain)?
clasp_width = 20;

// How tall (along the wall) should the piece be?
clasp_height = 50;

// Generic thickness of wall pieces:
wall_w = 2;


module holder()
{
  base_r = (clasp_width+2*gap_for_clasp_wh[0])/2;
  groove_off_center_r = clasp_rounding_r+0.5*clasp_width/2;
  difference()
  {
    union()
    {
      translate([base_r,0,clasp_height/2])
        rotate([-90,0,0])
          cylinder(r=base_r,h=wall_w);
      translate([gap_for_clasp_wh[0],0,clasp_height/2-2*clasp_rounding_r/2])
      {
        difference()
        {
          union()
          {
            translate([clasp_width/2,0,clasp_rounding_r])
              rotate([-90,0,0])
                cylinder(r=clasp_rounding_r,h=clasp_height_off_wall-clasp_rounding_r,$fn=40);
            translate([clasp_width/2,clasp_height_off_wall-clasp_rounding_r,clasp_rounding_r])
            {
              rotate([0,90,0])
              {
                sphere(r=clasp_rounding_r,$fn=40);
              }
            }
          }

          // The round part of the groove:
          translate([0,clasp_height_off_wall-clasp_rounding_r,clasp_rounding_r])
          {
            rotate([0,90,0])
            {
              rotate_extrude(angle=180, convexity=10)
              {
                translate([groove_off_center_r,clasp_width/2,0])
                  circle(r=clasp_width/2-wall_w,$fn=40);
              }
            }
          }

          // The (mostly cosmetic) cylinder cutout part of the groove:
          translate([clasp_width/2,wall_w,clasp_rounding_r])
          {
            for (zoff = [-groove_off_center_r,groove_off_center_r])
              translate([0,0,zoff])
                rotate([-90,0,0])
                  cylinder(r=clasp_width/2-wall_w,h=clasp_height_off_wall-clasp_rounding_r-wall_w,$fn=40);
          }
        }
      }
    }
    // cutout for the clasp that this mounts around:
    translate([gap_for_clasp_wh[0]+(clasp_width/2-gap_for_clasp_wh[0]/2),0,0])
      cube([gap_for_clasp_wh[0],gap_for_clasp_wh[1],clasp_height]);
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
  rotate([90,0,0])
  {
    holder();
  }
}
