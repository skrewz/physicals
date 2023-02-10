// Use partname to control which object is being rendered:
//
// _partname_values tray
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 8 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

wall_w = 2;
water_level = 2;
rounding_r = 3;

// This can't really be adjusted:
thread_r = 16;

hull_points = [[0,0], [0,20], [100,0], [100,100]];

module profile_pos()
{
  cylinder(r=5, h=wall_w+1*rounding_r);
}

module profile_neg()
{
  sphere(r=rounding_r);
}

module tray()
{
  translate([15,15,wall_w])
  {
    difference()
    {
      cylinder(r=thread_r, h=water_level);
      cylinder(r=thread_r-wall_w, h=water_level);
      for(r = [0:30:360])
      {
        rotate([0,0,r])
        {
          translate([0,-1,0])
            cube([thread_r,2,water_level]);
        }
      }
    }
    translate([0,0,water_level])
    {
      thread();
    }
  }
  difference()
  {
    hull()
    {
      for (t = hull_points)
      {
        translate(t)
        {
          profile_pos();
        }
      }
    }
    translate([0,0,rounding_r+wall_w])
    hull()
    {
      for (t = hull_points)
      {
        translate(t)
        {
          profile_neg();
        }
      }
    }
  }
}

module thread()
{
  intersection()
  {
    cylinder(r=thread_r,h=10);
    translate([0,0,10])
    {
      rotate([180,0,0])
      {
        import("includes/Cap_003.stl");
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
  tray();
} else if ("tray" == partname)
{
  tray();
}
