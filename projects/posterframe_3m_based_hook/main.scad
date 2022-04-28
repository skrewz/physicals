// Use partname to control which object is being rendered:
//
// _partname_values frame_hook
partname = "display";

include <libs/compass.scad>
include <libs/3m_hooks.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 12;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 2;

frame_hook_thickness = 3m_hook_insert_wd[1]+3m_hook_claspspace_clearance;

module frame_hook_pos()
{
  // The main case of the hook:
  hull()
  {
    cube([3m_hook_insert_wd[0],frame_hook_thickness,3m_hook_body_h_offsets[1]+3m_hook_claspspace_h]);
    translate([0,0,50])
      cube([3m_hook_insert_wd[0],1,0.01]);
  }

  // A hook attached to the case:
  translate([
    3m_hook_insert_wd[0]/2,
    0,
    30,
  ]) {
    hull()
    {
      translate([0,frame_hook_thickness+4,5])
        rotate([-90,0,0])
          cylinder(r=3, h=0.1, $fs=0.3);

      translate([0,0,-5])
        rotate([-90,0,0])
          cylinder(r=3, h=0.1, $fs=0.3);

      translate([0,frame_hook_thickness,-20])
        rotate([-90,0,0])
          cylinder(r=3, h=0.1, $fs=0.3);
    }
  }
}

module frame_hook()
{
  difference()
  {
    frame_hook_pos();
    translate([3m_hook_insert_wd[0],-0.01,0])
      mirror([1,0,0])
        mount_for_3m_adhesive_neg();
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
  frame_hook();
} else if ("frame_hook" == partname)
{
  frame_hook();
}
