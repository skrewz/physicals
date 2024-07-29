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


holder_wdh = [155,50,15];


wall_w = 2;

collet_cutout_r1 = 7.7/2;
collet_cutout_r2 = 9/2;
collet_cutout_h = 4;
nut_cutout_r = (19.15+0.5)/2;
nut_cutout_h = 6;

collet_inset = 15;
collet_interval = 25;

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

module er11_pos(label)
{
  translate([0,collet_inset+nut_cutout_r+1,holder_wdh[2]])
  {
    rotate([0,0,-90])
    {
      linear_extrude(height=1)
      {
        text(label, valign="center", halign="right");
      }
    }
  }
}

module er11_neg()
{
  translate([0,collet_inset,holder_wdh[2]-nut_cutout_h])
  {
    cylinder(r=nut_cutout_r, h=nut_cutout_h+0.02);
  }
  translate([0,collet_inset,holder_wdh[2]-nut_cutout_h-collet_cutout_h])
  {
    cylinder(r1=collet_cutout_r1, r2=collet_cutout_r2,h=collet_cutout_h+0.02);
  }
}

module holder()
{
  num_holders = (holder_wdh[0]-2*collet_inset)/collet_interval;
  difference()
  {
    union()
    {
      color("#000000c0")
      {
        holder_base();
      }
      // Add positive parts (mostly text)
      color("white")
      {
        for (i = [0:1:num_holders])
        {
          translate([collet_inset+i*collet_interval,0,0])
          {
            er11_pos(str(i));
          }
        }
      }
    }
    // Drill out for ER11s
    for (i = [0:1:num_holders])
    {
      translate([collet_inset+i*collet_interval,0,0])
      {
        er11_neg();
      }
    }

    // Drill out M3 mounting holes
    for (xoff = [2*holder_rounding_r, holder_wdh[0]-2*holder_rounding_r])
    {
      translate([xoff,holder_wdh[1]-2*holder_rounding_r,0])
      {
        translate([0,0,-0.01])
        {
          cylinder(r=1.8,h=holder_wdh[2]+0.01);
        }
        translate([0,0,holder_wdh[2]-4])
        {
          cylinder(r=3.5,h=4+0.02);
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
