// Use partname to control which object is being rendered:
//
// _partname_values holder
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 1;


holder_wdh = [180,45,10];

v_bit_box_wdh = [55.0+6.0,9.0+0.3,52];
other_bit_box_wdh = [52.5+6.0,10.3+0.3,84];

bit_holder_angle = 30;

wall_w = 2;
bit_holder_interval = 3;

bit_holder_yoff = 2.5;
bit_holder_initial_xoff = 10;

holder_rounding_r = holder_wdh[1]/10;

module holder_base()
{
  translate([holder_rounding_r,holder_rounding_r,0])
  {
    minkowski()
    {
      cube(holder_wdh-[2*holder_rounding_r,2*holder_rounding_r,0]);
      cylinder(r=holder_rounding_r,h=0.01);
    }
  }
}

module holder()
{
  difference()
  {
    holder_base();
    translate([bit_holder_initial_xoff,bit_holder_yoff,wall_w])
    {
      rotate([0,0,bit_holder_angle])
      {
        cube(v_bit_box_wdh);
      }
    }
    other_bit_xoff = bit_holder_initial_xoff + (bit_holder_interval+other_bit_box_wdh[1])/sin(bit_holder_angle);
    for (i=[0:3])
    {
      xoff = other_bit_xoff+i*(bit_holder_interval+other_bit_box_wdh[1])/sin(bit_holder_angle);
      translate([xoff,bit_holder_yoff,wall_w])
      {
        rotate([0,0,bit_holder_angle])
        {
          cube(other_bit_box_wdh);
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
