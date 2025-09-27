// Use partname to control which object is being rendered:
//
// _partname_values holder
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;


speaker_r = 73/2;
wall_w = 2;
holder_h = 10;

phone_holder_w = 15;
phone_holder_clasp_height = 4;
strap_pocket_w = 19;
strap_pocket_depth = 10;
strap_pocket_offset = 5;
strap_pocket_rotation = 130;

module holder()
{
  module phoneholder (include_shelf)
  {
    translate([-100/2,-100,0])
    {
      cube([100,100,wall_w]);
      if (include_shelf)
      {
        cube([100,wall_w,phone_holder_w+2*wall_w]);
        translate([0,wall_w,phone_holder_w+wall_w])
        {
          cube([100,phone_holder_clasp_height,wall_w]);
        }
      }
    }
  }



  module rotated_placed_phoneholder(include_shelf)
  {
    translate([0,-speaker_r,0])
    {
      rotate([70,0,0])
      {
        phoneholder(include_shelf);
      }
    }
  }

  difference()
  {
    union()
    {
      hull()
      {
        cylinder(r=speaker_r+wall_w, h=holder_h);
        // intersection()
        // {
        //   cylinder(r=2*speaker_r, h=holder_h);
          rotated_placed_phoneholder(false);
        // }
      }
      rotated_placed_phoneholder(true);
    }
    translate([0,0,-wall_w-100])
    {
      cylinder(r=speaker_r, h=holder_h+100);
    }
    rotate([0,0,strap_pocket_rotation]) 
    {
      translate([-strap_pocket_w/2,0,-strap_pocket_offset-100])
      {
        cube([strap_pocket_w,speaker_r+strap_pocket_depth,holder_h+100]);
      }
    }
    translate([0,0,-0.01])
    {
      cylinder(r=speaker_r-wall_w, h=holder_h+0.02);
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
  holder();
} else if ("holder" == partname)
{
  rotate([180,0,0])
  {
    holder();
  }
}
