// Use partname to control which object is being rendered:
//
// _partname_values straight_holder_lower_100
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;


wall_w = 1.5;
shelf_cutout_wd = [18.67+0.2, 30];

shelf_crimp_angle = 4;

acrylic_pane_cutout_wd = [3 + 0.1, 15];

// Latter "d" measurement is at the top:
acrylic_pane_cutout_offset_d = [0, 0];

module straight_holder_2d(type)
{
  square([shelf_cutout_wd[1]+wall_w,wall_w]);
  square([wall_w,shelf_cutout_wd[0]+2*wall_w]);
  top_outrigger_segment_length = (shelf_cutout_wd[1]-(acrylic_pane_cutout_wd[0]+2*wall_w-0.5*wall_w))/2;
  translate([acrylic_pane_cutout_wd[0]+2*wall_w-0.5*wall_w,shelf_cutout_wd[0]+wall_w])
  {
    rotate(-shelf_crimp_angle)
    {
      square([top_outrigger_segment_length,wall_w]);
      translate([top_outrigger_segment_length,0])
      {
      #
        rotate(2*shelf_crimp_angle)
        square([top_outrigger_segment_length,wall_w]);
      }
    }
  }

  acrylic_cutout_offset = acrylic_pane_cutout_offset_d[type == "upper" ? 1 : 0];

  translate([0,shelf_cutout_wd[0]+wall_w])
  {
    difference()
    {
      square([acrylic_pane_cutout_wd[0]+2*wall_w,wall_w+acrylic_cutout_offset+acrylic_pane_cutout_wd[1]]);
      translate([wall_w,wall_w+acrylic_cutout_offset])
      {
        square([acrylic_pane_cutout_wd[0],wall_w+acrylic_pane_cutout_wd[1]+0.01]);
      }
    }
  }
}

module straight_holder (type, length)
{
  linear_extrude(length)
  {
    straight_holder_2d(type);
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
  straight_holder("lower",100);
  translate([0,60,0])
  {
    straight_holder("upper",100);
  }
} else if ("straight_holder_lower_100" == partname)
{
  straight_holder("lower",100);
}
