// Use partname to control which object is being rendered:
//
// _partname_values round_foot rectangular_foot l_shaped_foot beam_foot
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 2;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

// This is the clearance you're aiming for, taking original_measured_clearance
// into account.
//
// Roughly speaking, this'll be the height of your vacuum cleaner's clearance.
desired_clearance = 105;

// This is the height of the highest object you can slide under all parts of
// the original sofa bed (err towards lower number):
//
// Since an IKEA Vimle sofa bed is an IKEA Vimle sofa bed, one wouldn't expect
// this number to vary between people. However, individual circumstances apply.
// One might have an anti-scratch cushion under this or one could have the sofa
// bed standing on a carpet that it sinks into.
//
// 19mm is arrived at with the large IKEA Trixig pads and on a hard floor
// surface.
original_measured_clearance = 19;

// Upper/lower diameter of conical round foot:
//
// Measurement notes:
// - Foot height Measured as 66mm (of which ~2mm is an anti-scratch piece, so,
//   64mm)
// - Measured 19mm of clearance under the bed-y parts. This needs to increase
//   to desired_clearance.
round_foot_height = (64+(desired_clearance-original_measured_clearance));
round_foot_r_upper = (100/2); // original round foot upper radius: 76mm/2
round_foot_r_lower = (90/2); // original round foot lower radius: 69mm/2
                             // On the lower (floor-side) side, the outside of the cone is rounded on the
                             // outside (visual) and on the inside (where a bolt goes through):
round_foot_lower_outer_rounding_r = 5;
round_foot_lower_inner_rounding_r = 1;

// The original IKEA foot has a built-in thread. This design will need its own bolt.
//
// Measured outer diameter of 7.8mm. Not sure where these bolts came from, but,
// will do the job.
bolt_cutout_r = (7.8/2)+0.2;
bolt_flathead_cutout_r = (14.55/2)+1;
// The amount of material under the bolt flathead to squeeze:
bolt_flathead_cutout_thickness = 3;


// The rectangular_foot() is the bit that rotates together with the inner
// mechanism and holds up the bed when it's extended (albeit, the rear ones are
// permanently on the floor).
// 
// All four rectangular_foot()'s are identical and slide onto a metal piece with
// some force.

rectangular_foot_base_wdh = [25, 60, 5+(desired_clearance-original_measured_clearance)];
// In the original foot, the metal leg is supported for 30mm with a 5mm base
// plate (i.e. the one that measures rectangular_foot_base_wdh).
//
// This build requires that to extend upwards by
// desired_clearance-original_measured_clearance. Thus adding that here.

rectangular_foot_support_hole_wdh = [11, 41, 30];
rectangular_foot_support_hole_wall_w = 2;

// The base should have slightly rounded corners to not grab and scratch
// things:
rectangular_foot_base_outer_rounding_r = 1;

// The original foot is 24mm total, of which 19.5mm is grab length:
l_shaped_foot_support_wd = [27, 27]; 
l_shaped_foot_support_height = 19.5;

// This is the height before we get to the grab height:
l_shaped_foot_base_height = desired_clearance-original_measured_clearance + (24-19.5);
// This is the thickness of the metal piece this fits onto:
l_shaped_foot_thickness = 3;
// This is the wall size of the constructod l_shaped_foot():
l_shaped_foot_support_wall_w = 2;
l_shaped_foot_support_magnet_wall_w = 0.3;

l_shaped_foot_magnet_cutout_rh = [(10+0.5)/2,3.2];

// Beam support radius
beam_foot_inner_r = (22.5)/2;
beam_foot_cutout_angle = 110;

// The wall width of the beam_foot():
beam_foot_wall_w = 2.5;

// The width of the beam_foot() attachment:
beam_foot_attachment_length = 50;

// The radius of the original IKEA foot that the beam_foot() attaches itself to:
beam_foot_round_knob_r = 23.2/2;

// An offset to allow the knob to snap in:
beam_foot_round_knob_offset = 0.5*beam_foot_round_knob_r;

// The angle (compared to the beam_foot()'s extending leg) that the knob exists
// at:
beam_foot_round_knob_angle = -10;

// The radius and length of the beam_foot() to the floor:
beam_foot_leg_rh = [13,123]; // TODO: measure

// The rounding of the feet as they hit the floor:
beam_foot_leg_rounding_r = 2;


module round_foot_pos()
{
  unrounded_height=round_foot_height-max(round_foot_lower_inner_rounding_r, round_foot_lower_outer_rounding_r) ;
  translate([0,0,round_foot_height - unrounded_height])
  {
    cylinder(
        h=unrounded_height,
        r1=round_foot_r_lower,
        r2=round_foot_r_upper
        );
  }
  translate([0,0,round_foot_height - unrounded_height])
  {
    hull()
    {
      rotate_extrude()
      {
        translate([round_foot_r_lower - round_foot_lower_outer_rounding_r,0])
        {
          rotate(90)
          {
            circle(r=round_foot_lower_outer_rounding_r,$fn=100);
          }
        }
      }
    }
  }
}

module round_foot_neg()
{
  translate([0,0,-0.05])
  {
    cylinder(r=bolt_cutout_r,h=round_foot_height+0.1);
    cylinder(r=bolt_flathead_cutout_r,h=round_foot_height-bolt_flathead_cutout_thickness);
  }
}

module round_foot()
{
  difference()
  {
    round_foot_pos();
    round_foot_neg();
  }

}

module rectangular_foot_pos()
{
  hull()
  {
    // Main extension leg, rounded:
    translate([rectangular_foot_base_outer_rounding_r,rectangular_foot_base_outer_rounding_r,rectangular_foot_base_outer_rounding_r])
    {
      minkowski()
      {
        cube(rectangular_foot_base_wdh-[2*rectangular_foot_base_outer_rounding_r,2*rectangular_foot_base_outer_rounding_r,2*rectangular_foot_base_outer_rounding_r]);
        sphere(r=rectangular_foot_base_outer_rounding_r, $fs=$preview ? 0.4 : 0.2);
      }
    }
    translate([
        rectangular_foot_base_wdh[0]/2-(rectangular_foot_support_hole_wdh[0]+2*rectangular_foot_support_hole_wall_w)/2,
        rectangular_foot_base_wdh[1]/2-(rectangular_foot_support_hole_wdh[1]+2*rectangular_foot_support_hole_wall_w)/2,
        rectangular_foot_base_wdh[2]])
    {
      cube(rectangular_foot_support_hole_wdh+[2*rectangular_foot_support_hole_wall_w, 2*rectangular_foot_support_hole_wall_w,0]);
    }
  }
}
module rectangular_foot_neg()
{
  translate([
      rectangular_foot_base_wdh[0]/2-(rectangular_foot_support_hole_wdh[0]+2*rectangular_foot_support_hole_wall_w)/2+rectangular_foot_support_hole_wall_w,
      rectangular_foot_base_wdh[1]/2-(rectangular_foot_support_hole_wdh[1]+2*rectangular_foot_support_hole_wall_w)/2+rectangular_foot_support_hole_wall_w,
      rectangular_foot_base_wdh[2]])
  {
    cube(rectangular_foot_support_hole_wdh+[0,0,0.05]);
  }
}
module rectangular_foot()
{
  difference()
  {
    rectangular_foot_pos();
    rectangular_foot_neg();
  }

}
module l_shaped_foot_pos()
{
  cube([
      2*l_shaped_foot_support_wall_w+l_shaped_foot_support_wd[0],
      2*l_shaped_foot_support_wall_w+l_shaped_foot_thickness,
      l_shaped_foot_base_height+l_shaped_foot_support_height]
      );
  cube([
      2*l_shaped_foot_support_wall_w+l_shaped_foot_thickness,
      2*l_shaped_foot_support_wall_w+l_shaped_foot_support_wd[1],
      l_shaped_foot_base_height+l_shaped_foot_support_height]
      );

  // The magnet slots::
  for (zoff = [
      l_shaped_foot_base_height+0.5*l_shaped_foot_support_height,
      0.4*l_shaped_foot_base_height,
  ]){
    translate([
        -(l_shaped_foot_magnet_cutout_rh[0]+l_shaped_foot_support_magnet_wall_w),
        (2*l_shaped_foot_support_wall_w+l_shaped_foot_support_wd[1])/2,
        zoff
    ]) {
      hull()
      {
        for(hullzoff = [0,-4*l_shaped_foot_magnet_cutout_rh[0]])
        {
          translate([0,0,hullzoff])
          {
            rotate([0,90,0])
            {
              cylinder(
                  r1=l_shaped_foot_magnet_cutout_rh[0]+l_shaped_foot_support_wall_w,
                  r2=l_shaped_foot_magnet_cutout_rh[0]+2*l_shaped_foot_support_wall_w,
                  h=l_shaped_foot_magnet_cutout_rh[1]+beam_foot_wall_w);
            }
          }
        }
      }
    }
  }
}
module l_shaped_foot_neg()
{
  translate([l_shaped_foot_support_wall_w,l_shaped_foot_support_wall_w,l_shaped_foot_base_height])
  {
    cube([2*l_shaped_foot_support_wall_w+l_shaped_foot_support_wd[0]-2*l_shaped_foot_support_wall_w, l_shaped_foot_thickness, l_shaped_foot_support_height+0.02]);
  }
  translate([l_shaped_foot_support_wall_w,l_shaped_foot_support_wall_w,l_shaped_foot_base_height])
  {
    cube([l_shaped_foot_thickness, 2*l_shaped_foot_support_wall_w+l_shaped_foot_support_wd[1]-2*l_shaped_foot_support_wall_w, l_shaped_foot_support_height+0.02]);
  }

  // Magnet cutouts (for 
  for (zoff = [
      l_shaped_foot_base_height+0.5*l_shaped_foot_support_height,
      0.4*l_shaped_foot_base_height,
  ]){
    translate([-l_shaped_foot_magnet_cutout_rh[0],(2*l_shaped_foot_support_wall_w+l_shaped_foot_support_wd[1])/2,zoff])
    {
      hull()
      {
        for(hullzoff = [0,-4*l_shaped_foot_magnet_cutout_rh[0]])
        {
          translate([0,0,hullzoff])
          {
            rotate([0,90,0])
            {
              cylinder(
                  r=l_shaped_foot_magnet_cutout_rh[0],
                  h=l_shaped_foot_magnet_cutout_rh[1]);
            }
          }
        }
      }
    }
  }
}

module l_shaped_foot()
{
  difference()
  {
    l_shaped_foot_pos();
    l_shaped_foot_neg();
  }

}
module beam_foot_pos()
{

  // The main barrel cylinder:
  rotate([0,90,0])
  {
    cylinder(r=beam_foot_inner_r+beam_foot_wall_w, h=beam_foot_attachment_length);
  }
  translate([beam_foot_leg_rh[0],0,0])
  {
    // The main  leg cylinder:
    mirror([0,0,1])
    {
      cylinder(r=beam_foot_leg_rh[0], h=beam_foot_leg_rh[1]-beam_foot_leg_rounding_r);
    }
    // The rounded edge where it touches the floor:
    translate([0,0,-(beam_foot_leg_rh[1]-beam_foot_leg_rounding_r)])
    {
      hull()
      {
        rotate_extrude()
        {
          translate([beam_foot_leg_rh[0] - beam_foot_leg_rounding_r,0])
          {
            rotate(90)
            {
              circle(r=beam_foot_leg_rounding_r,$fn=100);
            }
          }
        }
      }
    }
  }
}
module beam_foot_neg()
{
  translate([-0.01,0,0])
  {
    rotate([0,90,0])
    {
      // The main inner cut:
      cylinder(r=beam_foot_inner_r, h=beam_foot_attachment_length+0.02);
      // The cutout_angle'd piece:
      rotate([0,0,180-beam_foot_cutout_angle/2])
      {
        rotate_extrude(angle = beam_foot_cutout_angle)
        {
          square([2*beam_foot_inner_r,beam_foot_attachment_length+0.02]);
        }
      }
    }
  }
  rotate([180+beam_foot_round_knob_angle,0,0])
  {
    translate([beam_foot_attachment_length-beam_foot_round_knob_offset,0,0])
    {
      cylinder(r=beam_foot_round_knob_r, h=beam_foot_inner_r+beam_foot_wall_w);
    }
  }
}

module beam_foot()
{
  difference()
  {
    beam_foot_pos();
    beam_foot_neg();
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
  color("grey")
  {
    for (xoff = [0, 500])
    {
      for (yoff = [0, 200])
      {
        translate([xoff,yoff,0])
        {
          round_foot();
        }
      }
    }

    for (xoff = [100, 400])
    {
      for (yoff = [0, 200])
      {
        translate([xoff,yoff,0])
        {
          rectangular_foot();
        }
      }
    }
  }

  color("orange")
  {
    for (xoff = [100, 400])
    {
      translate([xoff,400,0])
      {
        l_shaped_foot();
      }
    }

    translate([100,600,beam_foot_leg_rh[1]])
    {
      beam_foot();
    }

    translate([400+beam_foot_attachment_length,600,beam_foot_leg_rh[1]])
    {
      beam_foot();
    }
  }
} else if ("round_foot" == partname)
{
  rotate([180,0,0])
  {
    round_foot();
  }
} else if ("rectangular_foot" == partname)
{
  rectangular_foot();
} else if ("l_shaped_foot" == partname)
{
  l_shaped_foot();
} else if ("beam_foot" == partname)
{
  rotate([0,-90,0])
  {
    beam_foot();
  }
}
