// Use partname to control which object is being rendered:
//
// _partname_values shelf
partname = "display";

// how thick we need to cut out for tape; should be less than actual tape
// thickness (to ensure adhesion):
double_adhesive_tape_thickness_cutout = 1.5;

cable_box_wdh = [160,160,30];
wall_thickness = 3;
adhesive_thickness = 1.5;

// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 12;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 2;

module shelf()
{
  difference()
  {
    cube([
      cable_box_wdh[0]+2*wall_thickness,
      cable_box_wdh[1]+1*wall_thickness,
      cable_box_wdh[2]+2*wall_thickness]);
    translate([wall_thickness,-0.02,wall_thickness])
      cube([
        cable_box_wdh[0],
        cable_box_wdh[1],
        cable_box_wdh[2]+2*wall_thickness]);
  }

  module adhesive_strip()
  {
    linear_extrude(height=wall_thickness)
    {
      polygon([
        [0, 0],
        [11, 0],
        [11, 60-11],
        [0, 60],
      ]);
    }
  }
  translate([0,0,cable_box_wdh[2]+wall_thickness-adhesive_thickness])
  {
    translate([cable_box_wdh[0]/2-50/2,cable_box_wdh[1]-11,0])
    {
      cube([50,11,wall_thickness]);
    }
    translate([wall_thickness,0,0])
    {
      adhesive_strip();
    }
    translate([cable_box_wdh[0]+wall_thickness,0,0])
    {
      mirror([1,0,0])
      {
        adhesive_strip();
      }
    }
  }

  /*
  intersection()
  {
    cube([cable_box_wdh[0]+cable_box_wdh[2],cable_box_wdh[1]+cable_box_wdh[2],cable_box_wdh[2]+2*wall_thickness]);
    translate([cable_box_wdh[2]+2*wall_thickness,cable_box_wdh[2]+2*wall_thickness,0])
    {
      minkowski()
      {
        // using the sphere entirely to dimension minkowski size:
        sphere(r=cable_box_wdh[2]+2*wall_thickness);
        cube([cable_box_wdh[0],cable_box_wdh[1],0.01]);
      }
    }
  }
  */
}


// Conventions:
// * When an object is rendered using partname, position/rotate it according to
//   printing suggestion, here. (The module itself will be positioned/rotated
//   like it will be, in the put-together "display" situation.)
// * The special value "display" for partname is the product picture for all
//   parts put together.
if ("display" == partname)
{
  shelf();
} else if ("shelf" == partname)
{
  rotate([90,0,0])
  {
    shelf();
  }
}
