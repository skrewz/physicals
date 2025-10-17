// Use partname to control which object is being rendered:
//
// _partname_values bowl_holder
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 2;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;


bowl_rd = [117/2,21.5+10];
bowl_rotation = 15;
feet_interval = (147-7.8);
feet_offset = bowl_rd[0]/2+20;
// (7.8+0.5)/2 is "snug"; opting for "loose" so that lifting the machine out
// for cleaning is effortless.
feet_r = (7.8+1.0)/2;
feet_ground_offset = 30;

finger_cutout_d = 8;
finger_cutout_rotations = [-110];

wall_w = 3;
brim_around_bowl = 6;


module bowl_holder()
{
  holder_h = bowl_rd[1]+wall_w;
  difference()
  {
    hull()
    {
      cylinder(r=bowl_rd[0]+brim_around_bowl, holder_h);

      translate([0,0,(bowl_rd[0]+brim_around_bowl)*sin(abs(bowl_rotation))])
      {
        rotate([bowl_rotation,0,0])
        {
          cylinder(r=bowl_rd[0]+brim_around_bowl, holder_h);
        }
      }
      translate([0,feet_offset,0])
      {
        for (xoff = [-feet_interval/2,feet_interval/2])
        {
          translate([xoff,0,0])
          {
            cylinder(r=feet_r+wall_w, h=holder_h+feet_ground_offset-feet_r);
          }
        }
      }
    }
    translate([0,feet_offset,feet_ground_offset])
    {
      for (xoff = [-feet_interval/2,feet_interval/2])
      {
        translate([xoff,0,0])
        {
          cylinder(r=feet_r, h=holder_h);
        }
        translate([xoff,0,holder_h-feet_ground_offset-feet_r])
        {
          cylinder(r1=feet_r, r2=feet_r+brim_around_bowl/2/2, h=feet_r+0.01);
        }
      }
    }
    // translate([0,0,wall_w+bowl_rd[0]*sin(abs(bowl_rotation))])
    translate([0,0,wall_w+bowl_rd[0]*sin(abs(bowl_rotation))])
    {
      rotate([bowl_rotation,0,0])
      {
        translate([0,0,-2*holder_h])
        {
          cylinder(r=bowl_rd[0], 3*holder_h+0.02);
        }
      }
    }
    /*
    for(zrot = finger_cutout_rotations)
    {
      rotate([0,0,zrot])
      {
        translate([0,0,bowl_rd[1]+wall_w])
        {
          rotate([90,0,0])
          {
            scale([2,1,1])
            {
              cylinder(r=finger_cutout_d, h=2*bowl_rd[0]);
            }
          }
        }
      }
    }
    */
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
  bowl_holder();
} else if ("bowl_holder" == partname)
{
  bowl_holder();
}
