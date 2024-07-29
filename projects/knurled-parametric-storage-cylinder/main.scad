// Use partname to control which object is being rendered:
//
// _partname_values inside outside
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 12;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

// Main parameters to tune:
//
// The height of the contained cylinder:
inner_height = 10.0 + 2; // 105.8 on caliper

// The amount of inner_height to actually thread (to not have to turn excessively)
thread_height = 6;
// The radius of the contained cylinder:
inner_radius = (78.0+1.0)/2; // 32.0 on caliper
// Basic wall width:
wall_w = 2;
// The height of the inside part's grip:
grip_height = 2;

// Whether to cause holes in the outside() and/or inside():
punch_holes_oi = [true, true];

// Parameters that are derived or somewhat tweakable:

// The height of the threads. The height difference between the tops of hills:
used_indent_height = 6;

// The indent of the thread. Make greater to get deeper grooves:
used_inner_indent = inner_radius / 32;

// The outside thread radius is a bit larger
outer_inner_radius = inner_radius + used_indent_height/3;
// The outer indent is ever so sligthly larger:
used_outer_indent = used_inner_indent + 0.5;


// Not meant to be tweaked, as such:
outer_radius_total = outer_inner_radius+
      wall_w+
      used_inner_indent+
      used_outer_indent+wall_w;

rounded_grip_extra_height = outer_radius_total/10;


assert(inner_height > rounded_grip_extra_height/2 + grip_height + thread_height);

module knurled_cylinder(r,h)
{
  difference()
  {
    cylinder(r=r,h=h);
    for (prefix = [1,-1])
      for(i=[0:59])
        rotate([0,0,i*6])
          linear_extrude(height=h+0.1,twist=prefix*120*(h/45))
            translate([r,0])
              circle(r=0.8,$fn=8);
  }
}

module hole_punch_pattern ()
{
  hole_punch_r = 1.5;
  num_holes = inner_radius / (3*hole_punch_r) - inner_radius % (3*hole_punch_r);

  for (j = [0:5])
  {
    for (i = [0:num_holes+1])
    {
      rotate([0,0,i*20+j*60])
      {
        translate([i * 3*hole_punch_r,0,-0.01])
        {
          cylinder(r=hole_punch_r, h=wall_w+0.02,$fs=$preview ? 1 : 0.5);
        }
      }
    }
  }
}

module thread(h,inner_r,wall_width,indent,indent_height)
{
  difference()
  {
    linear_extrude(height=h,twist=(-180*h*2)/indent_height)
      translate([indent,0])
        circle(r=inner_r+wall_width+indent,$fn=40);
  }
}

module inside ()
{
  difference()
  {
    union()
    {
      intersection()
      {
        union()
        {
          translate([0,0,rounded_grip_extra_height])
          {
            cylinder(r=outer_radius_total,h=rounded_grip_extra_height+grip_height,$fn=60);
            hull()
            {
              rotate_extrude(angle=360,convexity=60) {
                translate([outer_radius_total-rounded_grip_extra_height,0,0])
                  circle(r=rounded_grip_extra_height, $fs=$preview ? 1 : 0.5);
              }
            }
          }
        }
        // Using mirroring to better allow knurling to line up when closed (YMMV,
        // though):
        translate([0,0,grip_height+rounded_grip_extra_height])
          mirror([0,0,1])
            knurled_cylinder(r=outer_radius_total,h=grip_height+rounded_grip_extra_height,$fn=60);
      }
      translate([0,0,grip_height+rounded_grip_extra_height])
        thread(thread_height,inner_radius,wall_w,used_inner_indent,used_indent_height);

      translate([0,0,wall_w])
        cylinder(h=inner_height,r=inner_radius+wall_w,$fa=2);
    }
    translate([0,0,wall_w])
      cylinder(r=inner_radius,h=inner_height+0.01,$fn=60);
    if (punch_holes_oi[1])
    {
      hole_punch_pattern();
    }
  }
}


module outside ()
{
  module rounded_outside ()
  {
    cylinder(
      r=outer_radius_total,
      h=inner_height+wall_w,
      $fn=60);
    translate([0,0,inner_height+wall_w])
      sphere(r=outer_radius_total,$fn=60);
  }
  module knurled_outside ()
  {
    intersection()
    {
      union()
      {
        cylinder(r=outer_radius_total, h=inner_height+wall_w-rounded_grip_extra_height, $fs=$preview ? 5 : 1);
        translate([0,0,inner_height+wall_w-rounded_grip_extra_height])
        {
          hull()
          {
            rotate_extrude(angle=360,convexity=60) {
              translate([outer_radius_total-rounded_grip_extra_height,0,0])
                circle(r=rounded_grip_extra_height, $fs=$preview ? 1 : 0.5);
            }
          }
        }
      }
      knurled_cylinder(
        r=outer_radius_total,
        h=inner_height+wall_w+rounded_grip_extra_height,
        $fn=60);
    }
  }

  difference()
  {
    knurled_outside();

    translate([0,0,-0.01])
      thread(inner_height,
        outer_inner_radius,
        wall_w,
        used_outer_indent,
        used_indent_height);

    if (punch_holes_oi[0])
    {
      translate([0,0,inner_height])
      {
        hole_punch_pattern();
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
  translate([0,0,max(1.5*inner_height,50)])
    outside();
  inside();
} else if ("outside" == partname)
{
  rotate([0,180,0])
    outside();
} else if ("inside" == partname)
{
  inside();
}
