// Use partname to control which object is being rendered:
//
// _partname_values holder
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 12;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;


clasp_width = 80;
clasp_height = 40;
clasp_r = 14;

clasp_drillout_offsets = [0.3*clasp_width,0.55*clasp_width,0.8*clasp_width];
clasp_drillout_r1 = 3;
clasp_drillout_r2 = 1.5;

cable_minimum_drillout_r = 3;

clasp_overreach = 10;

wedge_dh = [100,40];
wedge_thickness = 2;

module squiggly_line (w,h,turns=3,track_width="default")
{
  actual_track_width = "default" == track_width ? w : track_width;

  projection()
  {
    rotate([-90,0,0])
      linear_extrude(twist=turns*360-180,height=h)
      {
        translate([actual_track_width,0,0])
          circle(r=w);
      }
  }
}

module holder()
{
  difference()
  {
    union()
    {
      cube([wedge_thickness,wedge_dh[0],wedge_dh[1]]);
      translate([0,wedge_dh[0],wedge_dh[1]-clasp_height])
      {
        translate([-clasp_overreach,0,0])
        intersection()
        {
          hull()
            for (xoff = [clasp_r,clasp_width-clasp_r])
              translate([xoff,0,0])
                rotate([0,0,90])
                  cylinder(r=clasp_r,h=clasp_height);
          cube([clasp_width,clasp_r,clasp_height]);
        }
      }
    }
    translate([0,wedge_dh[0],wedge_dh[1]-clasp_height])
      for(xoff = clasp_drillout_offsets)
      {
        // A squiggly line to enable insertion but prevent dropping out accidentally:
        translate([xoff-clasp_overreach,0,-0.01])
          translate([0,clasp_r/2-0.01,0])
          rotate([90,0,0])
            linear_extrude(height=clasp_r/2)
              squiggly_line(cable_minimum_drillout_r,clasp_height,turns=2.5, track_width=1.2*cable_minimum_drillout_r);

        // The main cable channel:
        hull()
        {
          for(xoff2 = [-clasp_drillout_r1/2, clasp_drillout_r1/2])
            translate([xoff-clasp_overreach+xoff2,clasp_r/2,-0.01])
              cylinder(r=clasp_drillout_r1,h=clasp_height+0.02);
        }

        // Both at top and bottom to allow it to be rotated for purpose:
        for (zoff = [0, clasp_height])
          hull()
            for(yoff = [0,clasp_r/2])
              translate([xoff-clasp_overreach,yoff,zoff])
                sphere(r=2*clasp_drillout_r1);
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
  rotate([180,0,0])
    holder();
}
