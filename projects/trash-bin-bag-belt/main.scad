// Use partname to control which object is being rendered:
//
// _partname_values segment
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 1;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

// Measurements for your trash bin:

// You'll generally want to subtract an amount to make the ring undersized.
upper_undersizing = 30;
lower_undersizing = 40;

// You'll also likely get this wrong. So there's some point to printing e.g.
// belt_segment_count//2+1 high-ish radius segments and belt_segment_count//2+1
// low-ish radius ones. (I.e. adjust both upper/lower undersizing for those).
upper_circumference = /* measured */ 703 - upper_undersizing;
lower_circumference = /* measured */ 596 - lower_undersizing;

// This is used to calculate hte bin_angle below:
height_between_circumferences = 260;

// Decisions you make:
belt_height = 30;
belt_girth = 8;
// How many pieces the belt should be printed as (lower for large printers):
belt_segment_count = 5;

keyhole_dimen = belt_girth/4;


// Derived values:
upper_r = upper_circumference/2/PI;
lower_r = lower_circumference/2/PI;
bin_angle = atan((upper_r - lower_r)/height_between_circumferences);

module keyhole (scalefactor,height)
{
  dim = scalefactor*keyhole_dimen;
  cylinder(r=dim, h=height,$fs=$preview?1:0.5);
  translate([0,-dim/2,0])
    cube([2*keyhole_dimen,dim,height]);
}

module segment()
{
  module _keyhole_offset_from_center (zoff, height, scalefactor=1)
  {
    translate([upper_r-belt_girth/2-(belt_height*sin(bin_angle)),0,0])
    {
      rotate([0,bin_angle,0])
      {
        translate([0,-2*keyhole_dimen,zoff])
        {
          rotate([0,0,90])
          {
            keyhole(scalefactor,height);
          }
        }
      }
    }
  }
  difference()
  {
    union()
    {
      // Wall of segment:
      rotate_extrude(angle=360/belt_segment_count, convexity=2,$fa=$preview?8:2,$fs=$preview?2:0.5)
      {
        translate([upper_r-belt_girth,0,0])
        {
          translate([belt_girth/2,belt_height])
          {
            circle(r=belt_girth/2);
          }
          polygon([
            [belt_girth,belt_height],
            [0,belt_height],
            [-tan(bin_angle)*belt_height,0],
            [-tan(bin_angle)*belt_height+belt_girth,0],
          ]);
        }
      }

      // Positive keyhole:
      _keyhole_offset_from_center(belt_height/5, belt_height/2);
    }
    
    // Negative keyhole:
    rotate([0,0,360/belt_segment_count])
    {
      // lattermost belt_height/5 is a slac space:
      _keyhole_offset_from_center(-belt_height/5, belt_height/2+belt_height/5+belt_height/5,1.3);
    }
  }
}

module display_bin()
{
  bin_wall_w = 3;
  display_upper_r = (upper_circumference+upper_undersizing)/2/PI;
  display_lower_r = (lower_circumference+lower_undersizing)/2/PI;
  difference()
  {
    cylinder(r1=display_lower_r+bin_wall_w,r2=display_upper_r+bin_wall_w,h=height_between_circumferences);
    translate([0,0,bin_wall_w])
    {
      cylinder(r1=display_lower_r,r2=display_upper_r,h=height_between_circumferences);
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
  % display_bin();
  for (i=[0:belt_segment_count])
  {
    // Lay them out to make it visible that they're segments:
    translate([upper_r+i*4*belt_girth,0,0])
    {
      segment();
    }
    translate([0,0,height_between_circumferences-belt_height])
    {
      rotate([0,0,i*360/belt_segment_count])
      {
        segment();
      }
    }
  }
} else if ("segment" == partname)
{
  rotate([0,0,0])
  {
    segment();
  }
}
