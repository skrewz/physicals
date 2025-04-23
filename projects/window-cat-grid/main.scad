// Use partname to control which object is being rendered:
//
// _partname_values holder
partname = "display";

include <libs/compass.scad>
include <libs/3m_hooks.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

// The number of curtain rods:
curtain_rod_count = 2;

// The distance betweeen curtain rods:
curtain_rod_interval = 80;

// The radius of the curtain rods:
curtain_rod_cutout_r = (32+1)/2;

// The length that the curtain rod should be supported for:
curtain_rod_grab_height = 10;
curtain_rod_grab_wall_w = 2;

// Derived:
holder_thickness = 2*mount_for_3m_adhesive_wdh[1] + 1;
holder_height = curtain_rod_grab_wall_w + curtain_rod_cutout_r + curtain_rod_count*curtain_rod_interval + curtain_rod_cutout_r + curtain_rod_grab_wall_w;
holder_width = 1.4*2*curtain_rod_cutout_r;
holder_3m_indentation = 5;

module _cylinder_holders(radius, height)
{
  for(i=[0:curtain_rod_count])
  {
    translate([holder_width/2,holder_thickness,curtain_rod_cutout_r+curtain_rod_grab_wall_w+i*curtain_rod_interval])
    {
      rotate([-90,0,0])
      {
        cylinder(r=radius, h=height);
      }
    }
  }
}

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
  translate([holder_width/2-mount_for_3m_adhesive_wdh[0]/2, -0.01, holder_height - mount_for_3m_adhesive_wdh[2] - holder_3m_indentation])
  {
    %
    // TODO: not quite finished:
    mount_for_3m_adhesive_visualisation();
  }
  hull()
  {
    for (zoff = [holder_width/2,holder_height-holder_width/2])
    {
      translate([holder_width/2,0,zoff])
      {
        rotate([-90,0,0])
        {
          cylinder(r=holder_width/2, h=holder_thickness);
        }
      }
    }
  }
  _cylinder_holders(curtain_rod_cutout_r+curtain_rod_grab_wall_w, curtain_rod_grab_height);
}

module holder_neg()
{
  translate([holder_width/2-mount_for_3m_adhesive_wdh[0]/2, -0.01, holder_height - mount_for_3m_adhesive_wdh[2] - holder_3m_indentation])
  {
    mount_for_3m_adhesive_neg();
  }
  _cylinder_holders(curtain_rod_cutout_r, curtain_rod_grab_height+0.02);
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
  rotate([90,0,0])
  {
    holder();
  }
}
