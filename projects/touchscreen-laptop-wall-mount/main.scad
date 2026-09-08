// Use partname to control which object is being rendered:
//
// _partname_values assembled_holder
partname = "display";

include <libs/compass.scad>
include <libs/3m_hooks.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 3;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.3;


// from back of display to top of ethernet port: 25mm (actual)
// nut endstops on corners: 4mm tall above back of display (actual)
// middle of USB-C plug: 111mm from other end of display (actual)

$fn=50;
laptop_outer_wh = [333+0.5, 228+0.5];
laptop_hh = [22, 19];

corner_nuts_wh_dist = [154.89, 92];

3m_attachment_w_dists = [
  laptop_outer_wh[0]-mount_for_3m_adhesive_wdh[0],
  (laptop_outer_wh[0]-mount_for_3m_adhesive_wdh[0])/2,
  0
];
3m_attachment_h_dists = [laptop_outer_wh[1]-mount_for_3m_adhesive_wdh[2], 0];

corner_nuts_h = 25+7.5   /* height to ethernet port from face of display */
- 4  /* height of corner nut holder */
- 7  /* thickness from base of display to face of display */;

longest_bolt_tight_height = 7; // from base of bolt head to beginning of thread

frame_radius = 25+7.5; // round totally flat at wall
wall_w = 2;
lip_wall_w = 1;
// Top then clockwise:
lip_insert_ds = [20, 11, 35, 11];

// From top to middle of plug(like defined with lip_insert_ds):
laptop_psu_offset = 70;
laptop_psu_hole_wh = [20,10];

// The shape of the volume that's to be cut out of the internal holder:
module internal_cutout_neg ()
{
  module place_attachments()
  {
    for(xoff = 3m_attachment_w_dists)
    {
      for(yoff = 3m_attachment_h_dists)
      {
        translate([xoff,yoff+mount_for_3m_adhesive_wdh[2],0])
        {
          rotate([90,0,0])
          {
            children();
          }
        }
      }
    }
  }
  difference()
  {
    union()
    {
      // Reuse lip widths for back holding planes:
      translate([lip_insert_ds[3],lip_insert_ds[2],-0.01])
      {
        difference()
        {
          cube([laptop_outer_wh[0]-(lip_insert_ds[3]+lip_insert_ds[1]),laptop_outer_wh[1]-(lip_insert_ds[0]+lip_insert_ds[2]),frame_radius-max(laptop_hh)+0.02]);
          translate([-lip_insert_ds[3],-lip_insert_ds[2],0])
          {
            place_attachments()
            {
              cube([mount_for_3m_adhesive_wdh[0], 2*mount_for_3m_adhesive_wdh[1], mount_for_3m_adhesive_wdh[2]]);
            }
          }
        }
      }
      translate([0,-frame_radius,frame_radius-max(laptop_hh)])
      {
        cube([laptop_outer_wh[0],laptop_outer_wh[1]+frame_radius,max(laptop_hh)-lip_wall_w]);
      }

      translate([-wall_w-0.01,laptop_psu_offset-laptop_psu_hole_wh[0]/2,frame_radius-max(laptop_hh)])
      {
        cube([wall_w+0.02,laptop_psu_hole_wh[0],laptop_psu_hole_wh[1]]);
      }
    }
  }
  xinset = (laptop_outer_wh[0]-corner_nuts_wh_dist[0])/2; // almost exactly 5mm
  yinset = (laptop_outer_wh[1]-corner_nuts_wh_dist[1])/2; // almost exactly 5mm


  // 3M command attachment:
  place_attachments()
  {
    difference()
    {
      // cube([mount_for_3m_adhesive_wdh[0], 2*mount_for_3m_adhesive_wdh[1], mount_for_3m_adhesive_wdh[2]]);
      mount_for_3m_adhesive_neg();
      // translate([xoff,yoff+mount_for_3m_adhesive_wdh[2],-0.2])
      // {
      //   rotate([90,0,0])
      //   {
      //     difference()
      //     {
      //       // cube([mount_for_3m_adhesive_wdh[0], 2*mount_for_3m_adhesive_wdh[1], mount_for_3m_adhesive_wdh[2]]);
      //       mount_for_3m_adhesive_neg();
      //     }
      //   }
      // }
    }
  }

  translate([lip_insert_ds[3],lip_insert_ds[2],frame_radius-lip_wall_w-0.01])
  {
    cube([laptop_outer_wh[0]-(lip_insert_ds[3]+lip_insert_ds[1]),laptop_outer_wh[1]-(lip_insert_ds[0]+lip_insert_ds[2]),lip_wall_w+0.02]);
  }
}

module assembled_holder()
{
  difference()
  {
    scale([1,0.6,1])
    {
      intersection()
      {
        translate([-wall_w,-frame_radius,-0.01])
          cube([laptop_outer_wh[0]+2*wall_w,(1/0.6)*(laptop_outer_wh[1]+2*frame_radius),frame_radius]);

        minkowski()
        {
          sphere(r=frame_radius,$fn=120);
          cube([laptop_outer_wh[0],(1/0.6)*laptop_outer_wh[1],0.001]);
        }
      }
    }
    translate([-frame_radius,-frame_radius,-frame_radius-0.01])
      cube([laptop_outer_wh[0]+2*frame_radius,laptop_outer_wh[1]+2*frame_radius,frame_radius+0.02]);
    // cut out the main internal space:
    translate([0,0,-0.01])
    {
      internal_cutout_neg();
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
    assembled_holder();
  }
} else if ("assembled_holder" == partname)
{
  assembled_holder();
}
