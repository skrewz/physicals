// Use partname to control which object is being rendered:
//
// _partname_values wall_mount
partname = "display";

include <libs/compass.scad>
include <libs/3m_hooks.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

mirror_cutout_wdh = [210+0.5,300+1.0,2.0+1.5];
mirror_lip_width = 4.0;

mirror_rot_xz = [10,10];
wall_w = 1.5;

module mirror_frame_pos()
{
  union()
  {
    translate([0,mirror_cutout_wdh[2]/2,-0.01])
    {
      cube([mirror_cutout_wdh[0],mirror_cutout_wdh[2],mirror_cutout_wdh[1]]);
    }
    translate([0,mirror_cutout_wdh[2]/2,-0.01])
    {
      for (coord = [
          [0,0],
          [mirror_cutout_wdh[0],0],
      ]){
        translate(coord)
        {
          sphere(r=mirror_cutout_wdh[2],$fn=30);
        }
      }
      rotate([0,90,0])
      {
        cylinder(r=mirror_cutout_wdh[2],h=mirror_cutout_wdh[0],$fn=30);
      }
      for (xoff = [0,mirror_cutout_wdh[0]])
      {
        translate([xoff,0,0])
        {
          cylinder(r=mirror_cutout_wdh[2],h=mirror_cutout_wdh[1],$fn=30);
        }
      }
    }
  }
}

module mirror_frame_neg()
{
  cube([mirror_cutout_wdh[0],mirror_cutout_wdh[2],mirror_cutout_wdh[1]]);
  translate([mirror_lip_width/2,0.01,mirror_lip_width/2])
  {
    mirror([0,1,0])
    {
      cube([mirror_cutout_wdh[0]-mirror_lip_width,max(mirror_lip_width,mirror_cutout_wdh[2])+0.01,mirror_cutout_wdh[1]]);
    }
  }
}

// Won't be handling the opposite case, here:
assert(mirror_rot_xz[0] > 0);
assert(mirror_rot_xz[1] > 0);

// Note: mirror_rot_xz[1] > 0 implies the mirror is leaning towards the viewer.
// Thus, the only correction w.r.t. the wall will be with mirror_rot_xz[1] as
// input:

module rotated_translate_frame()
{
  rotate([-90,0,0])
  {
    translate([
        0,
        -sin(mirror_rot_xz[1])*mirror_cutout_wdh[0]-mirror_cutout_wdh[2]-wall_w,
        0
    ]) {
      rotate([mirror_rot_xz[0],0,mirror_rot_xz[1]])
      {
        children();
      }
    }
  }
}

module wall_mount_solids()
{
  difference()
  {
    hull()
    {
      rotated_translate_frame() {
        mirror_frame_pos();
      }
      translate([0,0,-1])
      {
        linear_extrude(height=1)
        {
          projection()
          {
            rotated_translate_frame() {
              mirror_frame_pos();
            }
          }
        }
      }
    }
    rotated_translate_frame() {
      mirror_frame_neg();
    }
    // A flat cut for the bottom plate:
    translate([-mirror_cutout_wdh[0]/2,-mirror_cutout_wdh[1]/2,-mirror_cutout_wdh[2]])
    {
      cube([2*mirror_cutout_wdh[0],2*mirror_cutout_wdh[1],mirror_cutout_wdh[2]]);
    }
  }
}

module wall_mount()
{
  difference()
  {
    rotate([90,0,0])
    {
      wall_mount_solids();
    }

    for (coord = [
        [0.50*mirror_cutout_wdh[0],0,0],
        [0.1*mirror_cutout_wdh[0],0,mirror_cutout_wdh[1]-1.2*mount_for_3m_adhesive_wdh[2]],
        [0.9*mirror_cutout_wdh[0],0,mirror_cutout_wdh[1]-1.2*mount_for_3m_adhesive_wdh[2]],
    ]){
      translate(coord-[mount_for_3m_adhesive_wdh[0]/2,0,0]+[0,0.01,0])
      {
        mirror([0,1,0])
        {
          mount_for_3m_adhesive_neg();
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
  wall_mount();
} else if ("wall_mount" == partname)
{
  rotate([-90,0,0])
  {
    wall_mount();
  }
}
