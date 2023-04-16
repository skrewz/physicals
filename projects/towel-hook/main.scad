// Use partname to control which object is being rendered:
//
// _partname_values towel_hook
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 1 : 0.5;

wall_w = 5;

// Undersizing for a flexible and strong grab:
attachment_r = (25.4-1)/2;
attachment_grab_angle = 220;
mount_width = 10;

outrigger_length = 20;
hook_r = wall_w;
hook_angle = 260;

// Derived quantities:

compensated_mount_width = mount_width-2*wall_w/2;

module towel_hook()
{
  // The grabbing circle:
  rotate_extrude(angle=attachment_grab_angle)
  {
    translate([attachment_r,0])
    {
      square([wall_w,compensated_mount_width]);
      for (zoff = [0,compensated_mount_width])
      {
        translate([wall_w/2,zoff])
        {
          circle(r=wall_w/2);
        }
      }
    }
  }

  // Rounded ends of the grabbing circle:
  for (a = [0,attachment_grab_angle])
  {
    rotate([0,0,a])
    {
      translate([attachment_r+wall_w/2,0,0])
      {
        cylinder(r=wall_w/2, h=compensated_mount_width);
        for (zoff = [0,compensated_mount_width])
        {
          translate([0,0,zoff])
          {
            sphere(r=wall_w/2);
          }
        }
      }
    }
  }

  // The off-rigger from the grabbing circle:
  translate([attachment_r+wall_w/2,-wall_w/2,0])
  {
    cube([outrigger_length-wall_w/2,wall_w,compensated_mount_width]);
    translate([0,wall_w/2,0])
    {
      for (zoff = [0,compensated_mount_width])
      {
        translate([0,0,zoff])
        {
          rotate([0,90,0])
          {
            cylinder(h=outrigger_length-wall_w/2,r=wall_w/2);
          }
        }
      }
    }
  }

  // The hook end
  translate([attachment_r+outrigger_length,-hook_r-wall_w/2,0])
  {
    rotate([0,0,90])
    {
      rotate_extrude(angle=-hook_angle)
      {
        translate([hook_r,0])
        {
          square([wall_w,compensated_mount_width]);
          for (zoff = [0,compensated_mount_width])
          {
            translate([wall_w/2,zoff])
            {
              circle(r=wall_w/2);
            }
          }
        }
      }
      // Rounded end of the hook:
      rotate([0,0,-hook_angle])
      {
        translate([hook_r+wall_w/2,0,0])
        {
          cylinder(r=wall_w/2, h=compensated_mount_width);
          for (zoff = [0,compensated_mount_width])
          {
            translate([0,0,zoff])
            {
              sphere(r=wall_w/2);
            }
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
if ("display" == partname)
{
  translate([0,0,wall_w/2])
  {
    towel_hook();
  }
} else if ("towel_hook" == partname)
{
  towel_hook();
}
