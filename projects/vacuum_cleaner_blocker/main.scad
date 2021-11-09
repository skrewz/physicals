// Use partname to control which object is being rendered:
//
// _partname_values blocker_left blocker_middle blocker_right
partname = "display";

underspace_wd = [21,61];
space_width = 278;
support_depth = 100;
beam_wh = [10,15];
blocker_height = 90;


// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 12;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 0.5;

space_width_left = space_width/3;
space_width_right = space_width/3;
space_width_middle = space_width - space_width_left - space_width_right;

keyhole_dimen = min(beam_wh[0],beam_wh[1])/2-2;
keyholes_yoffs = [0.5*beam_wh[0],1.5*beam_wh[0]];

module keyhole (scalefactor,height)
{
  dim = scalefactor*keyhole_dimen;
  cylinder(r=dim, h=height);
  translate([0,-dim/2,0])
    cube([2*keyhole_dimen,dim,height]);
}

module blocker_left()
{
  difference()
  {
    union()
    {
      // y==0 reach-left beam
      translate([-2*underspace_wd[0],0,0])
        cube([2*underspace_wd[0],beam_wh[0],beam_wh[1]]);

      // y==underspace_wd[1] reach-left beam
      translate([-2*underspace_wd[0],underspace_wd[1]-beam_wh[0],0])
        cube([2*underspace_wd[0],beam_wh[0],beam_wh[1]]);

      // lengthy underspace filler:
      translate([-underspace_wd[0],underspace_wd[1],0])
        cube([beam_wh[0],support_depth-underspace_wd[1]/2,beam_wh[1]]);

      /* // underspace reacher to avoid getting pushed away */
      /* mirror([1,0,0]) */
      /*   cube([2*underspace_wd[0],underspace_wd[1],beam_wh[1]]); */
      translate([-2*underspace_wd[0],0,0])
        cube([beam_wh[0],underspace_wd[1],beam_wh[1]]);

      // lengthy underspace filler:
      /* cube([beam_wh[0],support_depth,beam_wh[1]]); */
      cube([space_width_left,beam_wh[0],blocker_height]);
      translate([space_width_left-beam_wh[0],beam_wh[0],-0.01])
        cube([beam_wh[0],beam_wh[0],beam_wh[1]]);
    }

  for (yoff = keyholes_yoffs)
    translate([space_width_left-2*keyhole_dimen,yoff,-0.01])
      keyhole(1.1,2+beam_wh[1]);
  }
}

module blocker_middle()
{
  difference()
  {
    union()
    {
      for (yoff = keyholes_yoffs)
        translate([-2*keyhole_dimen,yoff,0])
          keyhole(0.9,beam_wh[1]);
      cube([space_width_left,beam_wh[0],blocker_height]);
      translate([space_width_left-beam_wh[0],beam_wh[0],-0.01])
        cube([beam_wh[0],beam_wh[0],beam_wh[1]]);

      translate([0,beam_wh[0],-0.01])
        cube([beam_wh[0],beam_wh[0],beam_wh[1]]);
    }
    union()
    {
      for (yoff = keyholes_yoffs)
        translate([space_width_left-2*keyhole_dimen+0.01,yoff,-0.02])
          keyhole(1.1,2+beam_wh[1]);
    }
  }
}

module blocker_right()
{
  difference()
  {
    union()
    {
      for (yoff = keyholes_yoffs)
        translate([-2*keyhole_dimen,yoff,-0.01])
          keyhole(0.9,beam_wh[1]);
      translate([0,beam_wh[0],0])
        cube([beam_wh[0],beam_wh[0],beam_wh[1]]);
      cube([space_width_right,beam_wh[0],blocker_height]);
      translate([space_width_left-beam_wh[0],beam_wh[0],-0.01])
        cube([beam_wh[0],support_depth,beam_wh[1]]);
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
  blocker_left();
  translate([space_width_left+0.5,0,0])
    blocker_middle();
  translate([space_width_left+0.5+space_width_middle+0.5,0,0])
    blocker_right();
} else if ("blocker_left" == partname)
{
  blocker_left();
} else if ("blocker_middle" == partname)
{
  blocker_middle();
} else if ("blocker_right" == partname)
{
  blocker_right();
}
