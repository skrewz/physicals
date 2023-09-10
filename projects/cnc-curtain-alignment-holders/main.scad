// Use partname to control which object is being rendered:
//
// _partname_values holder aligner
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

width = 20;
holder_buffer_distance = 70;
aligner_radius = 20;
aligner_segment_lengths = [30,20];

frame_grab_height = 30;
wall_w = 3;
tape_height = 15;

module aligner()
{
  cube([width,wall_w,frame_grab_height]);
  translate([0,0,frame_grab_height-wall_w])
  {
    mirror([0,1,0])
    {
      cube([width,aligner_segment_lengths[0]+wall_w,wall_w]);
      translate([0,aligner_segment_lengths[0]+wall_w,-(aligner_radius-wall_w)])
      {
        intersection()
        {
          cube([width,aligner_segment_lengths[1],aligner_radius]);
          rotate([0,90,0])
          {
            difference()
            {
              cylinder(r=aligner_radius,h=width);
              translate([0,0,-0.01])
              {
                cylinder(r=aligner_radius-wall_w,h=width+0.02);
              }
            }
          }
        }
      }
    }
  }
}

module holder()
{
  cube([width,wall_w,frame_grab_height]);
  translate([0,0,frame_grab_height-wall_w])
  {
    cube([width,holder_buffer_distance,wall_w]);
    translate([0,holder_buffer_distance,0])
    {
      cube([width,wall_w,wall_w+tape_height]);
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
  for (xoff=[0,100,200])
  {
    translate([xoff,0,0])
    {
      holder();
      translate([0,-20,0])
      {
        aligner();
      }
    }
  }
} else if ("aligner" == partname)
{
  rotate([0,90,0])
  {
    aligner();
  }
} else if ("holder" == partname)
{
  rotate([0,90,0])
  {
    holder();
  }
}
