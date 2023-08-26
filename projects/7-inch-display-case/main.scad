// Use partname to control which object is being rendered:
//
// _partname_values assembled_holder left_part right_part
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
display_outer_wh = [164.9+0.5, 102+0.5];
corner_nuts_wh_dist = [154.89, 92];

3m_attachment_w_dists = [display_outer_wh[0]-mount_for_3m_adhesive_wdh[0], 0];

corner_nuts_h = 25+7.5   /* height to ethernet port from face of display */
                - 4  /* height of corner nut holder */
                - 7  /* thickness from base of display to face of display */;

longest_bolt_tight_height = 7; // from base of bolt head to beginning of thread

frame_radius = 25+7.5; // round totally flat at wall
wall_w = 2;


// The shape of the volume that's to be cut out of the internal holder:
module internal_cutout_neg ()
{
  // Helper module for the nut-and-bolt together mechanism
  module tightening_clasp ()
  {
    difference()
    {
      intersection()
      {
        rotate([0,90,40])
        {
          translate([0,0,-20])
          {
            cylinder(r=6,h=30);
          }
        }

        rotate([0,90,-40])
        {
          translate([0,0,-20])
          {
            cylinder(r=6,h=30);
          }
        }
      }
      rotate([0,90,0])
        translate([0,3,-10])
        cylinder(r=2,h=20,$fn=20);
    }
  }

  difference()
  {
    cube([display_outer_wh[0],display_outer_wh[1],frame_radius+0.01]);
    xinset = (display_outer_wh[0]-corner_nuts_wh_dist[0])/2; // almost exactly 5mm
    yinset = (display_outer_wh[1]-corner_nuts_wh_dist[1])/2; // almost exactly 5mm



    // bolts through hole for tightening parts together:
    translate([display_outer_wh[0]/2,0,6])
    {
      tightening_clasp();
    }

    translate([display_outer_wh[0]/2,display_outer_wh[1],6])
    {
      mirror([0,1,0])
      tightening_clasp();
    }


    difference()
    {
      union ()
      {
        // 3M command attachment:
        for(xoff = 3m_attachment_w_dists)
        {
          translate([xoff,mount_for_3m_adhesive_wdh[2],0])
          {
            rotate([90,0,0])
            {
              difference()
              {
                cube([mount_for_3m_adhesive_wdh[0], 2*mount_for_3m_adhesive_wdh[1], mount_for_3m_adhesive_wdh[2]]);
                mount_for_3m_adhesive_neg();
              }
            }
          }
        }

        // Mount blocks for display:
        for(xoff = [xinset, display_outer_wh[0]-xinset])
        {
          for(yoff = [yinset, display_outer_wh[1]-yinset])
          {
            translate([xoff,yoff])
            {
              translate([-6,-6,corner_nuts_h])
              {
                mirror([0,0,1])
                cube([12,12,longest_bolt_tight_height]);
              }
            }
          }
        }
      }

      for(xoff = [xinset, display_outer_wh[0]-xinset])
      {
        for(yoff = [yinset, display_outer_wh[1]-yinset])
        {
          translate([xoff,yoff])
          {
            // Mount holes for display:
            cylinder(r=2,h=corner_nuts_h+0.02,$fn=20);
            // Hole for tool access:
            translate([0,0,-0.01])
            {
              cylinder(r=4,h=corner_nuts_h-longest_bolt_tight_height+0.01,$fn=20);
            }
          }
        }
      }
    }
  }
}

module assembled_holder()
{
  difference()
  {
    scale([1,0.6,1])
    intersection()
    {
      translate([-wall_w,-frame_radius,-0.01])
      cube([display_outer_wh[0]+2*wall_w,(1/0.6)*(display_outer_wh[1]+2*frame_radius),frame_radius]);

      minkowski()
      {
        sphere(r=frame_radius,$fn=120);
        cube([display_outer_wh[0],(1/0.6)*display_outer_wh[1],0.001]);
      }
    }
    translate([-frame_radius,-frame_radius,-frame_radius-0.01])
      cube([display_outer_wh[0]+2*frame_radius,display_outer_wh[1]+2*frame_radius,frame_radius+0.02]);
    // cut out the main internal space:
    translate([0,0,-0.01])
      internal_cutout_neg();

    // cut out power supply cable exit hole:
    // (this version bends the cable fairly heavily, but then it exits at wall level)
    translate([111-(10/2),0.01,0])
    {

      mirror([0,1,0])
      cube([10,frame_radius+0.02,3]);
    }
        translate([111,0.01,2])
        {
          rotate([90,0,0])
          cylinder(r1=10,r2=3,h=frame_radius+0.02);
        }
    /*
    translate([111,0.01,5])
    {
      mirror([0,1,0])
      cube([15,frame_radius,7]);
    }
    */
    /*
    hull()
    {
      {
        translate([111,0.01,5])
        {
          rotate([90,0,0])
          cylinder(r1=4,r2=4,h=frame_radius+0.02);
        }

        translate([111,0.01,12])
        {
          rotate([90,0,0])
          cylinder(r1=8,r2=3,h=frame_radius+0.02);
        }
      }
    }
    */
  }
}

module left_part ()
{
  intersection()
  {
    assembled_holder();
    translate([display_outer_wh[0]/2,-frame_radius,0])
    {
      cube([display_outer_wh[0]/2+wall_w,display_outer_wh[1]+2*frame_radius,100]);
    }
  }
}

module right_part ()
{
  intersection()
  {
    assembled_holder();
    translate([-wall_w,-frame_radius,0])
    {
      cube([display_outer_wh[0]/2+wall_w,display_outer_wh[1]+2*frame_radius,100]);
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
} else if ("left_part" == partname)
{
  rotate([0,90,0])
  {
    left_part();
  }
} else if ("right_part" == partname)
{
  rotate([0,-90,0])
  {
    right_part();
  }
}
