// Use partname to control which object is being rendered:
//
// _partname_values holder
partname = "holder";
include <libs/compass.scad>


// from the center of the clasps (with a middle where the vertical support
// connects), how deep is the horizontal support:
horizontal_offset_segments = [20,30];
vertical_support_height = 72;
wall_thickness = 7;
piece_width = 15;

clasp_r = 2.5;

glass_stem_r = 4;

// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 12;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 2;

module clasp_cutout(r=clasp_r)
{
  translate([0,-0.01,0])
    hull()
      for(xoff=[0,10])
        translate([xoff,0,0])
          rotate([-90,0,0])
            cylinder(r=r,h=piece_width+0.02,$fs=0.2);
}

module holder_pos()
{
  translate([0,0,vertical_support_height])
  {
    // leading towards rack clasp:
    mirror([1,0,0])
      cube([clasp_r+horizontal_offset_segments[0],piece_width,wall_thickness]);

    // leading towards glass stem clasp:
    cube([glass_stem_r+horizontal_offset_segments[1],piece_width,wall_thickness]);
  }
  // vertical post
  translate([-wall_thickness/2,0,0])
    cube([wall_thickness,piece_width,vertical_support_height]);

}
module holder_neg()
{
  // glass stem holder:
  translate([0,0,vertical_support_height])
    translate([horizontal_offset_segments[1],0,0])
      translate([0,piece_width/2,0])
        translate([0,0,-0.01])
          rotate([0,0,-45]) 
            cube([2*glass_stem_r,2*glass_stem_r,piece_width]);
        /* rotate([90,0,0]) */
        /*   clasp_cutout(glass_stem_r); */

  // towards rack clasp:
  translate([0,0,vertical_support_height+wall_thickness/2])
    mirror([1,0,0])
      translate([horizontal_offset_segments[0],0,0])
        clasp_cutout();

  // bottom of vertical post, also rack clasp:
  translate([0,0,clasp_r])
    rotate([0,90,0])
      clasp_cutout();
}

module holder ()
{
  difference()
  {
    holder_pos();
    holder_neg();
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
  rotate([90,0,0])
  {
    holder();
  }
}
