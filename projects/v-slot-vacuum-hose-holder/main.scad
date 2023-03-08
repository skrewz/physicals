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


vacuum_hose_r = (40-2)/2;
vacuum_hose_opening_factor = 1.6;

mount_point_height_difference = 20;
arm_girth = 15;

vacuum_hose_holder_length = mount_point_height_difference+20;
vacuum_hose_holder_offset = 40;

// TODO: measure
bolt_r = (3.8+0.6)/2;
bolt_head_r = (7+2)/2;
bolt_head_hold_girth = 2.5;




wall_w = 2.3;

module holder()
{
  difference()
  {
    holder_pos();
    holder_neg();
  }
}
module holder_pos()
{
   // Outrigger piece:
   translate([-arm_girth/2,0,0])
   {
    difference(){
      cube([arm_girth,vacuum_hose_holder_offset,vacuum_hose_holder_length]);
      translate([-0.01,vacuum_hose_holder_offset/2,vacuum_hose_holder_length/2])
      {
        rotate([0,90,0])
        {
          cylinder(r=min(vacuum_hose_holder_length/2, vacuum_hose_holder_offset/2)-2*wall_w,h=arm_girth+0.02);
        }
      }
    }
   }

   // Tube holder itself:
   translate([0,vacuum_hose_holder_offset+vacuum_hose_r,0])
   {
     difference()
     {
       cylinder(r=vacuum_hose_r+wall_w, h=vacuum_hose_holder_length);
       translate([0,0,-0.01])
       {
         cylinder(r=vacuum_hose_r, h=vacuum_hose_holder_length+0.02);
         translate([-vacuum_hose_opening_factor*vacuum_hose_r/2,0,-0.01])
           cube([vacuum_hose_opening_factor*vacuum_hose_r,vacuum_hose_r+wall_w,vacuum_hose_holder_length+0.03]);
       }
     }
   }
}

module holder_neg()
{
  bottom_bolt_zoff = (vacuum_hose_holder_length-mount_point_height_difference)/2;
  for (zoff = [bottom_bolt_zoff, bottom_bolt_zoff+mount_point_height_difference])
  {
    translate([0,-0.01,zoff])
    {
      rotate([-90,0,0])
      {
        cylinder(r=bolt_r,h=vacuum_hose_holder_offset+2*wall_w);
        translate([0,0,bolt_head_hold_girth])
        {
          cylinder(r=bolt_head_r,h=vacuum_hose_holder_offset+2*wall_w);
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
  holder();
} else if ("holder" == partname)
{
  rotate([0,0,0])
  {
    holder();
  }
}
