// Use partname to control which object is being rendered:
//
// _partname_values left_f_shape left_f_upper right_f_shape right_f_upper middle_t_shape middle_t_upper wall_clasp top_blocker tightening_clasp
partname = "display";

include <libs/compass.scad>
include <libs/metric_bolts_and_nuts.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 3;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

// Measured variables:

// The distance betwen the plates (needs to allow curtain to pass, narrower allows less light in)
interval_between_plates = 22;
shared_upper_cutout_length = 80;

right_f_outrigger_length = 60;
right_f_upper_cutout_length = 70;
right_f_upper_cutout_radius = 30;
right_f_height = 85;
left_f_height = 48; // TODO: measure this
left_f_outrigger_length = 60;

middle_t_l_outrigger_length = 60;
middle_t_r_outrigger_length = 40;
middle_t_height = 80; // TODO: measure this
middle_t_upper_cutout_length = shared_upper_cutout_length;
middle_t_upper_cutout_radius = 10;


// Chosen variables:
segment_length = 130;
fastening_width = 30;
fastening_height = 50;
wall_w = 2;
wall_w_thin = 0.8;

keyhole_thickness = wall_w;
keyhole_outrigger_length = 8;
keyhole_outrigger_width = 6;
keyhole_radius = 6;
keyhole_negative_thickness = 1.35*keyhole_thickness;
keyhole_negative_radius = 1.10*keyhole_radius;
keyhole_negative_outrigger_length = 1.1*keyhole_outrigger_length;
keyhole_negative_outrigger_width = 1.25*keyhole_outrigger_width;

keyhole_negative_oversizing_depth_addition = keyhole_thickness/4;

support_beam_r = 19/2;
support_beam_holder_height = 1.5*support_beam_r;
counter_rotation_length = 10;

wall_clasp_wh = [40,80];
wall_clasp_width_location_fraction = 0.7;
wall_clasp_offset = 28.5+support_beam_r; // from wall to cylinder centre
wall_clasp_clickthrough_w = 0.85*2*support_beam_r;

// adding wall_w here to compensate for inside-mounted overlap
top_blocker_curtain_r = 56/2+wall_w;
top_blocker_curtain_angle_start = 90;
top_blocker_curtain_angle_end = -10;
top_blocker_extension = 40; // from radial centre to wall
top_blocker_extension_z_offset = -13;
top_blocker_extension_attachment_h = 30;


// Derived numbers:
keyhole_compensation_length = keyhole_negative_outrigger_length+keyhole_negative_radius;

module keyhole (radius, outrigger_length, outrigger_width, thickness, compensate_elephants_foot=false)
{
  $fn=25;
  translate([-outrigger_width/2,0,0])
  {
    cube([outrigger_width,outrigger_length,thickness]);
    if (compensate_elephants_foot)
    {
      linear_extrude(height=thickness)
      {
        polygon([
          [-outrigger_width/4,0],
          [outrigger_width/2,outrigger_length/2],
          [outrigger_width+outrigger_width/4,0],
        ]);
      }
    }
    translate([outrigger_width/2,outrigger_length,0])
    {
      cylinder(r=radius,h=thickness);
    }
  }
}

module keyholed_plate_pos(plate_width, plate_thickness, plate_length, keyhole_positions=false)
{
  cube([plate_width,plate_thickness,plate_length]);

  xoffs = false != keyhole_positions ? keyhole_positions : [0.25*plate_width, 0.75*plate_width];
  for (xoff = xoffs)
  {
    translate([xoff,keyhole_thickness,segment_length])
    {
      rotate([90,0,0])
      {
        keyhole(
          keyhole_radius,
          keyhole_outrigger_length,
          keyhole_outrigger_width,
          keyhole_thickness);
      }
    }
  }
}

module keyholed_plate_neg(plate_width, plate_thickness, plate_length, hollowed=false, supported_in_hollowing=true, keyhole_positions=false)
{
  // place keyhole negatives:
  xoffs = false != keyhole_positions ? keyhole_positions : [0.25*plate_width, 0.75*plate_width];
  for (xoff = xoffs)
  {
    translate([xoff,keyhole_negative_thickness-0.01,-0.01])
    {
      rotate([90,0,0])
      {
        keyhole(
          keyhole_negative_radius,
          keyhole_negative_outrigger_length, // this is kept fixed to avoid snagging
          keyhole_negative_outrigger_width,
          keyhole_negative_thickness,
          compensate_elephants_foot=true);
      }
    }
  }
  // hollow out if asked for:
  if (hollowed)
  {
    hollowing_length = plate_length
      -keyhole_negative_radius
      -keyhole_negative_outrigger_length
      -plate_thickness;

    hollowing_angle = atan(hollowing_length/(plate_width-2*plate_thickness));
    difference()
    {
      translate([plate_thickness,-0.02,plate_length-hollowing_length])
      {
        cube([plate_width-2*plate_thickness,plate_thickness+0.04,hollowing_length-plate_thickness]);
      }

      if (supported_in_hollowing)
      {
        for (tup = [
           [plate_thickness, 0],
           [plate_width-plate_thickness, 1],
        ]) {
          translate([tup[0],-0.01,plate_length-hollowing_length])
          {
            mirror([tup[1],0,0])
            {
              rotate([0,90-hollowing_angle,0])
              {
                cube([plate_thickness,plate_thickness,hollowing_length/sin(hollowing_angle)]);
              }
            }
          }
        }
      }
    }
  }
}


module fastening_pos(fastening_width, fastening_height)
{
  translate([-fastening_width/2-wall_w,0,0])
  {
    cube([fastening_width+2*wall_w,fastening_height,wall_w]);
  }
}

module fastening_neg(fastening_width, fastening_height)
{
  translate([0,0,-0.01])
  {
    linear_extrude(height=3*wall_w)
    {
      polygon([
        [-fastening_width/2,fastening_height-wall_w-fastening_width/2],
        [-fastening_width/2,wall_w],
        [fastening_width/2,wall_w],
        [fastening_width/2,fastening_height-wall_w-fastening_width/2],
        [0,fastening_height-wall_w],
      ]);
    }
  }
}

module t_shape(outrigger_length_l, outrigger_length_r, height, version_upper=false)
{
  module t_shape_pos()
  {

    // Front plate
    translate([-outrigger_length_l,0,0])
    {
      cube([outrigger_length_l+outrigger_length_r,wall_w_thin,segment_length]);
    }

    // (thicker) rear plate:
    translate([-outrigger_length_l,interval_between_plates,0])
    {
      cube([outrigger_length_l+outrigger_length_r,wall_w,segment_length-(version_upper ? middle_t_upper_cutout_length : 0)]);
    }

    // // primary keyholed plate
    // translate([-outrigger_length_l,interval_between_plates,0])
    // {
    //   keyholed_plate_pos(outrigger_length_l+outrigger_length_r,wall_w,segment_length);
    // }


    for (tup = [
      [0,support_beam_holder_height],
      [segment_length-2*support_beam_holder_height-(version_upper ? middle_t_upper_cutout_length : 0), 2*support_beam_holder_height]
    ]) {
      translate([0,interval_between_plates+support_beam_r+wall_w,tup[0]])
      {
        cylinder(r=support_beam_r+wall_w,h=tup[1]);
      }
    }
    // between-plates beam:
    translate([wall_w,wall_w_thin,0])
    {
      rotate([0,0,90])
      {
        cube([interval_between_plates,wall_w,segment_length]);
      }
    }
    if (! version_upper)
    {
      // aligners to avoid rotation
      for (xoff = [-outrigger_length_l,outrigger_length_r-counter_rotation_length])
      {
        translate([xoff,interval_between_plates+wall_w,segment_length-counter_rotation_length])
        {
          cube([counter_rotation_length,wall_w,2*counter_rotation_length]);
        }
      }
    }
  }

  module t_shape_neg()
  {
    translate([0,interval_between_plates+support_beam_r+wall_w,-0.01])
    {
      cylinder(r=support_beam_r,h=segment_length+0.02);
      // elephant's foot compensation:
      cylinder(r1=support_beam_r+wall_w/2,r2=support_beam_r,h=wall_w);

      translate([-wall_w/2,0,0])
      {
        cube([wall_w,2*support_beam_r,segment_length+0.02]);
      }
    }
    if (version_upper)
    {
      translate([0,interval_between_plates,segment_length-(middle_t_upper_cutout_length-middle_t_upper_cutout_radius)])
      {
        hull ()
        {
          for(zoff = [0,segment_length])
          {
            translate([0,0,zoff])
            {
              rotate([0,90,0])
              {
                translate([0,0,-wall_w])
                {
                  cylinder(r=middle_t_upper_cutout_radius, h=3*wall_w);
                }
              }
            }
          }
        }
      }
    }
    translate([0,interval_between_plates+support_beam_r+2*wall_w,segment_length-2*support_beam_holder_height-(version_upper ? middle_t_upper_cutout_length : 0)])
    {
      translate([-(support_beam_r+wall_w), -(support_beam_r+wall_w), 0])
      {
        intersection()
        {
          translate([0,0,-0.01])
          {
            cube([2*(support_beam_r+wall_w), 2*(support_beam_r+wall_w), 2*2*(support_beam_r+wall_w)]);
          }
          rotate([-45,0,0])
          {
            cube([2*(support_beam_r+wall_w), 2*(support_beam_r+wall_w), 2*2*(support_beam_r+wall_w)]);
          }
        }
      }
    }
  }

  difference()
  {
    t_shape_pos();
    t_shape_neg();
  }
}

module f_shape(outrigger_length_l, height, version_upper = false)
{
  module f_shape_pos()
  {
    // Front plate (thinner when not version_upper to save material)
    translate([-outrigger_length_l,0,0])
    {
      hull()
      {
        cube([outrigger_length_l,wall_w_thin,wall_w]);
        translate([0,0,wall_w])
        {
          cube([outrigger_length_l,(version_upper ? wall_w : wall_w_thin),segment_length-wall_w]);
        }
      }
    }

    // (thicker) rear plate:
    translate([-outrigger_length_l,interval_between_plates,0])
    {
      cube([outrigger_length_l,wall_w,segment_length-(version_upper ? right_f_upper_cutout_length : 0)]);
    }

    // between-plates beam:
    translate([0,0,0])
    {
      cube([wall_w,interval_between_plates+height,segment_length]);
    }

    translate([-(outrigger_length_l-2*support_beam_r),0,0])
    {
      for (tup = [
        [0,support_beam_holder_height],
        [segment_length-2*support_beam_holder_height-(version_upper ? right_f_upper_cutout_length : 0), 2*support_beam_holder_height]
      ]) {
        translate([0,interval_between_plates+support_beam_r+wall_w,tup[0]])
        {
          cylinder(r=support_beam_r+wall_w,h=tup[1]);
        }
      }
    }
    // Tabs to hold together pieces:
    if (! version_upper)
    {
      translate([-outrigger_length_l,interval_between_plates+wall_w,segment_length-counter_rotation_length])
      {
        cube([outrigger_length_l,wall_w,2*counter_rotation_length]);
      }
      translate([-wall_w,interval_between_plates+wall_w,segment_length-counter_rotation_length])
      {
        cube([wall_w,height-wall_w,2*counter_rotation_length]);
      }
    }
  }
  module f_shape_neg()
  {
    translate([-(outrigger_length_l-2*support_beam_r),interval_between_plates+support_beam_r+wall_w,-0.01])
    {
      cylinder(r=support_beam_r,h=segment_length+counter_rotation_length+0.02);
      // Compensate so that the tabs can fit above:
      translate([0,0,segment_length])
      {
        cylinder(r=support_beam_r+1.2*wall_w,h=counter_rotation_length+0.02);
      }
      // elephant's foot compensation:
      cylinder(r1=support_beam_r+wall_w/2,r2=support_beam_r,h=wall_w);

      translate([-wall_w/2,0,0])
      {
        cube([wall_w,2*support_beam_r,segment_length+0.02]);
      }
    }
    translate([-(outrigger_length_l-2*support_beam_r),interval_between_plates+support_beam_r+2*wall_w,segment_length-2*support_beam_holder_height-(version_upper ? right_f_upper_cutout_length : 0)])
    {
      translate([-(support_beam_r+wall_w), -(support_beam_r+wall_w), 0])
      {
        intersection()
        {
          translate([0,0,-0.01])
          {
            cube([2*(support_beam_r+wall_w), 2*(support_beam_r+wall_w), 2*2*(support_beam_r+wall_w)]);
          }
          rotate([-45,0,0])
          {
            cube([2*(support_beam_r+wall_w), 2*(support_beam_r+wall_w), 2*2*(support_beam_r+wall_w)]);
          }
        }
      }
    }

    if (version_upper)
    {
      translate([0,4*wall_w+right_f_upper_cutout_radius,segment_length-(right_f_upper_cutout_length-right_f_upper_cutout_radius)])
      {
        hull ()
        {
          for(yoff = [0,height+interval_between_plates])
          {
            for(zoff = [0,segment_length])
            {
              translate([0,yoff,zoff])
              {
                rotate([0,90,0])
                {
                  translate([0,0,-wall_w])
                  {
                    cylinder(r=right_f_upper_cutout_radius, h=3*wall_w);
                  }
                }
              }
            }
          }
        }
      }
    }
  }

  difference()
  {
    f_shape_pos();
    f_shape_neg();
  }
}

module middle_t_shape()
{
  t_shape(middle_t_l_outrigger_length, middle_t_r_outrigger_length, middle_t_height);
}

module middle_t_upper()
{
  t_shape(middle_t_l_outrigger_length, middle_t_r_outrigger_length, middle_t_height, version_upper=true);
}

module right_f_shape()
{
  f_shape(right_f_outrigger_length, right_f_height);
}

module right_f_upper()
{
  f_shape(right_f_outrigger_length, right_f_height, version_upper=true);
}

module left_f_shape()
{
  mirror([1,0,0])
  {
    f_shape(left_f_outrigger_length, left_f_height);
  }
}
module left_f_upper()
{
  mirror([1,0,0])
  {
    f_shape(left_f_outrigger_length, left_f_height, version_upper=true);
  }
}

module wall_clasp()
{
  module wall_clasp_pos()
  {
    cube([wall_clasp_wh[0],wall_w,wall_clasp_wh[1]]);
    translate([wall_clasp_width_location_fraction*wall_clasp_wh[0]-(support_beam_r+wall_w)/2,0,0])
    {
      cube([support_beam_r+wall_w,wall_clasp_offset,support_beam_holder_height]);
    }
    translate([wall_clasp_width_location_fraction*wall_clasp_wh[0],wall_clasp_offset,0])
    {
      cylinder(r=support_beam_r+wall_w,h=support_beam_holder_height);
    }
  }

  module wall_clasp_neg()
  {
    translate([wall_clasp_width_location_fraction*wall_clasp_wh[0],wall_clasp_offset,-0.01])
    {
      cylinder(r=support_beam_r,h=support_beam_holder_height+0.02);
      translate([-wall_clasp_clickthrough_w/2,0,0])
      {
        cube([wall_clasp_clickthrough_w,2*support_beam_r,support_beam_holder_height+0.02]);
      }
    }
  }

  difference()
  {
    wall_clasp_pos();
    wall_clasp_neg();
  }
}

module top_blocker()
{
  tape_attachment_length = 20;
  tape_thickness = 1.5; // TODO: measure
  top_blocker_extension_without_tape = top_blocker_extension - tape_thickness;
  difference()
  {

    union()
    {
      // main light blocking panel:
      translate([0,0,top_blocker_extension_z_offset])
      {
        cube([segment_length,top_blocker_extension,wall_w]);
      }

      // taps and such for double-adhesive tape holding:
      for (xoff = [0,segment_length-tape_attachment_length-2*counter_rotation_length])
      {
        translate([xoff,0,0])
        {
          for (zoff = [0,min(top_blocker_extension_attachment_h,top_blocker_curtain_r)])
          {
            translate([0,0,zoff])
            {
              // the main L shape of the extension:
              translate([0,0,top_blocker_extension_z_offset])
              {
                // Some weird back-and-forth translation to facilitate building triangles:
                translate([tape_attachment_length,top_blocker_extension_without_tape,0])
                {
                  for (rot = [0,30])
                  {
                    rotate([0,0,rot])
                    {
                      translate([-tape_attachment_length,-top_blocker_extension_without_tape,0])
                      {
                        cube([tape_attachment_length,top_blocker_extension_without_tape,wall_w]);
                      }
                    }
                  }
                }
              }
            }
            translate([0,top_blocker_extension_without_tape-wall_w,top_blocker_extension_z_offset])
            {
              cube([tape_attachment_length,wall_w,top_blocker_extension_attachment_h]);
            }
          }
        }
      }

      // The main body of the blocker:
      //
      rotate([0,90,0])
      {
        cylinder(r=wall_w+top_blocker_curtain_r, h=segment_length);
      }

      // a counter_rotation_length-sized overlap
      translate([-counter_rotation_length,0,0])
      {
        rotate([0,90,0])
        {
          cylinder(r=wall_w+top_blocker_curtain_r, h=counter_rotation_length);
          translate([0,0,counter_rotation_length])
          {
            cylinder(r1=wall_w+top_blocker_curtain_r-wall_w,r2=wall_w+top_blocker_curtain_r, h=counter_rotation_length);
          }
        }
      }
    }
    // main cutout for curtain:
    rotate([0,90,0])
    {
      translate([0,0,counter_rotation_length])
      {
        cylinder(r=top_blocker_curtain_r, h=segment_length+0.02);
      }
    }

    // cutout for overlap
    translate([-counter_rotation_length-0.01,0,0])
    {
      // An offsetin here; to allow the main channel to get fully seated, leave
      // some space:
      overlap_oversink = 1;

      rotate([0,90,0])
      {
        // the ramp up to the indented part:
        translate([0,0,counter_rotation_length])
        {
          cylinder(r1=top_blocker_curtain_r-wall_w, r2=top_blocker_curtain_r, h=overlap_oversink+counter_rotation_length);
        }
        // the indented part:
        cylinder(r=top_blocker_curtain_r-wall_w, h=overlap_oversink+counter_rotation_length);

        // the cutout for the next segment to hold on to:
        difference()
        {
          cylinder(r=top_blocker_curtain_r+1.1*wall_w, h=overlap_oversink+counter_rotation_length);
          translate([0,0,-0.01])
          {
            cylinder(r=top_blocker_curtain_r-0.1*wall_w, h=overlap_oversink+counter_rotation_length+0.02);
          }
        }
      }
    }

    // lazy; should have done a rotate_extrude, merely cutting out pieces here:
    assert(top_blocker_curtain_angle_start-top_blocker_curtain_angle_end > 90);
    translate([-counter_rotation_length-0.01,0,0])
    {
      for (rot = [top_blocker_curtain_angle_end:(top_blocker_curtain_angle_start-top_blocker_curtain_angle_end)/5:top_blocker_curtain_angle_start])
      {
        rotate([rot,0,0])
        {
          mirror([0,1,0])
          {
            cube([segment_length+counter_rotation_length+0.02,2*(top_blocker_curtain_r+wall_w),2*(top_blocker_curtain_r+wall_w+wall_w)]);
          }
        }
      }
    }
  }
}

module tightening_clasp()
{
  difference()
  {
    union()
    {
      cylinder(r=support_beam_r+wall_w,h=2*support_beam_holder_height);
      translate([-(support_beam_r+wall_w),-(support_beam_r+wall_w),0])
      {
        cube([2*(support_beam_r+wall_w),3*(support_beam_r+wall_w),sin(45)*2*(support_beam_holder_height+wall_w)]);
      }
    }
    union()
    {
      translate([0,0,-0.01])
      {
        cylinder(r=support_beam_r,h=2*support_beam_holder_height+0.02);
        translate([-(support_beam_r+wall_w)-0.01, -(support_beam_r+wall_w), 0])
        {
          rotate([-45,0,0])
          {
            mirror([0,1,0])
            {
              cube([2*(support_beam_r+wall_w)+0.02, 2*(support_beam_r+wall_w), 2*2*(support_beam_r+wall_w)]);
            }
          }
        }
        translate([-(support_beam_r+wall_w)-0.01,-(3*(support_beam_r+wall_w)-1.1*wall_w),0])
        {
          cube([2*(support_beam_r+wall_w)+0.02, 2*(support_beam_r+wall_w), 2*2*(support_beam_r+wall_w)]);
        }
      }
      // cutting out space to put counteracting M3 bolts:
      translate([-(support_beam_r+wall_w)+wall_w,(support_beam_r+wall_w)-0.01,-0.01])
      {
        cube([2*(support_beam_r+wall_w)-2*wall_w,1*(support_beam_r+wall_w)+0.02,3*support_beam_holder_height+0.02]);
      }
      for (zoff = [0.3*support_beam_holder_height,1.2*support_beam_holder_height])
      {
        translate([-(support_beam_r+wall_w)-0.01,(support_beam_r+wall_w)+wall_w+0.5*support_beam_r,zoff])
        {
          rotate([0,90,0])
          {
            cylinder(r=m3_radius_for_cutaway,h=2*(support_beam_r+wall_w)+0.02,$fs=0.7);
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
display_interval = max(3*right_f_outrigger_length);

if ("display" == partname)
{
  wall_clasp();
  translate([wall_clasp_wh[0]/2,wall_clasp_offset,2+support_beam_holder_height])
  {
    tightening_clasp();
  }

  translate([0,0,1.1*segment_length])
  {
    top_blocker();
  }

  translate([1*display_interval,0,0])
  {
    left_f_shape();

    translate([0,0,1.1*segment_length])
    {
      left_f_upper();
    }
  }
  translate([2*display_interval,0,0])
  {
    middle_t_shape();

    translate([0,0,1.1*segment_length])
    {
      middle_t_upper();
    }
  }
  translate([3*display_interval,0,0])
  {
    right_f_shape();

    translate([0,0,1.1*segment_length])
    {
      right_f_upper();
    }
  }
} else if ("left_f_shape" == partname)
{
  left_f_shape();
} else if ("left_f_upper" == partname)
{
  left_f_upper();
} else if ("middle_t_upper" == partname)
{
  middle_t_upper();
} else if ("middle_t_shape" == partname)
{
  middle_t_shape();
} else if ("right_f_shape" == partname)
{
  right_f_shape();
} else if ("right_f_upper" == partname)
{
  right_f_upper();
} else if ("wall_clasp" == partname)
{
  wall_clasp();
} else if ("top_blocker" == partname)
{
  top_blocker();
} else if ("tightening_clasp" == partname)
{
  tightening_clasp();
}
