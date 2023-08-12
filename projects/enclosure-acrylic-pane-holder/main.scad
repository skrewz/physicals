// Use partname to control which object is being rendered:
//
// _partname_values top_holder bottom_holder top_handle pane_handle
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 1 : 0.5;


wall_w = 3;
acrylic_w_cutout = 3+1.2;
holder_width = 25;

bolt_support_thickness = 1;
bolt_cutout_r = 1.5+0.3;
bolt_head_rh = [5.45/2+0.3,3.3];

hinge_offset_hd = [9,2];

hinge_dimen = 2*wall_w+2*bolt_cutout_r;

hinge_handle_length = 30;
hinge_clamp_length = 20;

holder_thickness = bolt_support_thickness+bolt_head_rh[1];

pane_handle_length = 130;

module hinge_pos(segment_count, holder_first,thinning=0.0)
{
  cube([
    holder_width,
    holder_thickness,
    hinge_dimen/2,
  ]);

  // Rounded part of hinge:
  translate([0,hinge_dimen/2,hinge_dimen/2])
  {
    rotate([0,90,0])
    {
      cylinder(r=hinge_dimen/2, h=holder_width);
    }
  }
}

module hinge_neg(segment_count, holder_first,thinning=0.0)
{
  // Bolt through hole:
  translate([-0.01,hinge_dimen/2,hinge_dimen/2])
  {
    rotate([0,90,0])
    {
      cylinder(r=bolt_cutout_r, h=holder_width+0.02);
    }
  }

  // Cutout for hinge connect:
  //for (xoff = [1*holder_width/segment_count, 3*holder_width/segment_count, 5*holder_width/segment_count])
  for (i = [(holder_first?1:0):2:segment_count])
  {
    xoff = i*holder_width/segment_count;
    translate([xoff-0.01-thinning/2,-0.01,0])
    {
      cube([holder_width/segment_count+0.02+thinning,hinge_dimen+0.02,hinge_dimen]);
    }
  }
}

module top_holder()
{
  holder_height = 20+hinge_offset_hd[0];

  difference()
  {
    union()
    {
      cube([
        holder_width,
        holder_thickness,
        holder_height,
      ]);
      translate([0,holder_thickness,holder_height])
      {
        rotate([90,0,0])
        {
          hinge_pos(5, true);
        }
      }
    }
    translate([0,holder_thickness,holder_height])
    {
      rotate([90,0,0])
      {
        hinge_neg(5, true);
      }
    }
    for (xoff = [1*holder_width/5, 4*holder_width/5])
    {
      translate([xoff,0,20/2])
      {
        rotate([-90,0,0])
        {
          translate([0,0,-0.01])
          {
            cylinder(r=bolt_cutout_r, h=holder_thickness+0.02);
          }

          translate([0,0,-0.01])
          {
            cylinder(r=bolt_head_rh[0], h=holder_thickness-bolt_support_thickness);
          }
        }
      }
    }
  }
}

module top_handle()
{
  difference()
  {
    union()
    {
      // Handle outrigger:
      translate([0,-hinge_handle_length,0])
      {
        cube([
          holder_width,
          hinge_handle_length,
          holder_thickness,
        ]);
      }

      // Handle cylinder:
      translate([0,-hinge_handle_length,0])
      {
        rotate([0,90,0])
        {
          cylinder(r=holder_thickness, h=holder_width);
        }
      }

      // Clamp:
      translate([0,-hinge_offset_hd[1]-holder_thickness,-hinge_clamp_length])
      {
        cube([
          holder_width,
          holder_thickness,
          hinge_clamp_length,
        ]);
      }
      translate([0,0,holder_thickness])
      {
        rotate([-90,0,0])
        {
          hinge_pos(5, false, 0.5);
        }
      }
    }
    translate([0,0,holder_thickness])
    {
      rotate([-90,0,0])
      {
        hinge_neg(5, false, 0.5);
      }
    }
  }
}

module bottom_holder()
{
  difference()
  {
    union()
    {
      cube([holder_width,wall_w,8]);
      translate([0,wall_w/2,8])
      {
        rotate([0,90,0])
        {
          cylinder(r=wall_w/2, h=holder_width);
        }
      }
      cube([holder_width,wall_w+acrylic_w_cutout+wall_w,wall_w]);
      translate([0,wall_w+acrylic_w_cutout,0])
      {
        difference()
        {
          union()
          {
            cube([holder_width,bolt_support_thickness+bolt_head_rh[1],20-wall_w-bolt_support_thickness]);
            intersection()
            {
              cube([holder_width,bolt_support_thickness+bolt_head_rh[1],20]);
              translate([0,wall_w+bolt_support_thickness,20-wall_w-bolt_support_thickness])
              {
                rotate([0,90,0])
                {
                  cylinder(r=wall_w+bolt_support_thickness, h=holder_width);
                }
              }
            }
          }
        }
      }
    }
    translate([0,wall_w+acrylic_w_cutout+bolt_support_thickness+bolt_head_rh[1],0])
    {
      for (xoff = [1*holder_width/5, 4*holder_width/5])
      {
        translate([xoff,0,20/2])
        {
          rotate([90,0,0])
          {
            translate([0,0,-0.01])
            {
              cylinder(r=bolt_cutout_r, h=2*wall_w+acrylic_w_cutout+bolt_support_thickness+bolt_head_rh[1]);
            }

            translate([0,0,bolt_support_thickness])
            {
              cylinder(r=bolt_head_rh[0], h=2*wall_w+acrylic_w_cutout+bolt_support_thickness+bolt_head_rh[1]);
            }
          }
        }
      }
    }
  }
}

module pane_handle()
{
  pane_handle_rounding_r = holder_thickness;
  pane_handle_grip_r = holder_width/4;
  pane_handle_grip_height = holder_width;

  // Base plate:
  intersection()
  {
    cube([
      holder_width,
      holder_thickness,
      pane_handle_length
    ]);
    translate([pane_handle_rounding_r,pane_handle_rounding_r,pane_handle_rounding_r])
    {
      minkowski()
      {
        cube([
          holder_width-2*pane_handle_rounding_r,
          holder_thickness,
          pane_handle_length-2*pane_handle_rounding_r
        ]);
        sphere(r=pane_handle_rounding_r);
      }
    }
  }

  // Safety glasses holder
  translate([holder_width,-11/2,0])
  {
    difference()
    {
      cylinder(r=11/2+wall_w,h=40);
      translate([0,0,-0.01])
      {
        cylinder(r=11/2,h=40+0.02);
      }
    }
  }

  // Handle posts:
  for (zoff = [1*pane_handle_length/7,6*pane_handle_length/7])
  {
    translate([holder_width/2,0,zoff])
    {
      translate([0,-pane_handle_grip_height,0])
      {
        sphere(r=pane_handle_grip_r);
      }
      rotate([90,0,0])
      {
        cylinder(r=pane_handle_grip_r,h=pane_handle_grip_height);
      }
    }
  }
  // Handle bar:
  translate([holder_width/2,-pane_handle_grip_height,1*pane_handle_length/7])
  {
    cylinder(r=pane_handle_grip_r,h=5*pane_handle_length/7);
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
  translate([0,0,50])
  {
    top_holder();
  }
  translate([50,0,50])
  {
    pane_handle();
  }
  translate([0,50,50])
  {
    top_handle();
  }
  bottom_holder();
} else if ("top_holder" == partname)
{
  rotate([-90,0,0])
  {
    top_holder();
  }
} else if ("top_handle" == partname)
{
  rotate([180,0,0])
  {
    top_handle();
  }
} else if ("pane_handle" == partname)
{
  rotate([-90,0,0])
  {
    pane_handle();
  }
} else if ("bottom_holder" == partname)
{
  bottom_holder();
}
