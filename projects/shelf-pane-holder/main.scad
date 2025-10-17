// Use partname to control which object is being rendered:
//
// _partname_values corner endpiece
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;


wall_w = 2;

pane_indentation = 1;
pane_thickness = 9.1;
pane_grab_length = 20;


shelf_beam_cutout_wd = [16.2,16.2];
shelf_beam_cutout_grab_depth = 4;
// how much of a beam to grab onto:
shelf_beam_grab_length = 150;

module paneholder (pane_indentation = pane_indentation)
{
  difference()
  {
    cube([
        pane_indentation+pane_grab_length,
        pane_thickness+2*wall_w,
        shelf_beam_grab_length,
    ]);
    translate([pane_indentation,wall_w,-0.01])
    {
      cube([
          pane_grab_length+wall_w,
          pane_thickness,
          shelf_beam_grab_length+0.02,
      ]);
    }
  }
}

module corner()
{
  difference()
  {
    cube([
        shelf_beam_cutout_wd[0]+2*wall_w,
        shelf_beam_cutout_wd[1]+2*wall_w,
        shelf_beam_grab_length,
    ]);
    translate([-shelf_beam_cutout_grab_depth,-shelf_beam_cutout_grab_depth,-0.01])
    {
      cube([
          shelf_beam_cutout_wd[0]+wall_w,
          shelf_beam_cutout_wd[1]+wall_w,
          shelf_beam_grab_length+0.02,
      ]);
    }
    translate([wall_w,wall_w,-0.01])
    {
      cube([
          shelf_beam_cutout_wd[0],
          shelf_beam_cutout_wd[1],
          shelf_beam_grab_length+0.02,
      ]);
    }
  }
  translate([shelf_beam_cutout_wd[0]+wall_w,0,0])
  {
    paneholder();
  }
  translate([0,shelf_beam_cutout_wd[1]+2*wall_w,0])
  {
    rotate([0,0,90])
    {
      mirror([0,1,0])
      {
        paneholder();
      }
    }
  }
}

module endpiece()
{
  difference()
  {
    cube([
        shelf_beam_cutout_wd[0]+2*wall_w,
        shelf_beam_cutout_wd[1]+2*wall_w,
        shelf_beam_grab_length,
    ]);
    translate([0,wall_w,-0.01])
    {
      cube([
          shelf_beam_cutout_wd[0]+wall_w+0.01,
          shelf_beam_cutout_wd[1],
          shelf_beam_grab_length+0.02,
      ]);
    }
  }
  translate([shelf_beam_cutout_wd[0]+2*wall_w,0,0])
  {
    paneholder();
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
  corner();
  translate([100,0,0])
  {
    endpiece();
  }
} else if ("endpiece" == partname)
{
  endpiece();
} else if ("corner" == partname)
{
  corner();
}
