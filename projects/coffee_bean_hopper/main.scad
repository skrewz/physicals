// Use partname to control which object is being rendered:
//
// _partname_values hopper
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 3;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

wall_w = 2;
// caliper measurements:
// hopper clasp outer diameter: 68.71 (actual)
// hopper clasp height: 16.3 (min)
// holder indent-cut diameter: 65.75 (max)
// hopper throughfare diameter: 29.27 (actual)
// hopper screwhole radial offset: 57.63/2=28.81 (actual)
// hopper mechanism opening offset: 29.25 (actual)

hopper_total_h = 80;
hopper_wall_w = wall_w;

hopper_clasp_od = 68.5;
hopper_clasp_h = 17;
hopper_clasp_indent_cut_d = 65.0;

hopper_throughhole_d = 29.5;

hopper_od = hopper_clasp_od;

// FIXME: a guess:
hopper_clasp_indent_cut_angle = 57;
// FIXME: measure:
hopper_clasp_frill_offset = 29.3;
hopper_clasp_frill_rd = [2.5,7];
hopper_clasp_frill_angle = 55;
hopper_clasp_frill_angular_offset = 90;

hopper_clasp_hole_offset = 29;
hopper_clasp_hole_r = 2;
hopper_clasp_hole_d = 8;
hopper_clasp_hole_angular_offset = 47;

module hopper()
{
  difference()
  {
    hopper_pos();
    hopper_neg();
  }
}

module hopper_neg()
{
  // cut out for spherical part of hopper:
  translate([0,0,hopper_od/2])
    sphere(r=hopper_od/2-hopper_wall_w);

  // cylindrical cutout for hopper:
  translate([0,0,hopper_od/2])
    translate([0,0,-0.01])
      cylinder(r=hopper_od/2-hopper_wall_w, h=hopper_total_h-hopper_clasp_od/2+0.03);

  // indent cutouts for base:
  for(ang = [0,180])
  {
    rotate([0,0,ang-hopper_clasp_indent_cut_angle/2])
      rotate_extrude(angle=hopper_clasp_indent_cut_angle)
        translate([hopper_clasp_indent_cut_d/2,0,0])
          square([hopper_clasp_od/2-hopper_clasp_indent_cut_d/2+wall_w,hopper_clasp_h]);
  }

  // throughhole cutout:
  translate([0,0,-0.01])
    cylinder(r=hopper_throughhole_d/2, h=hopper_clasp_h);

  for(ang = [0,180])
  {
    // frill cutout
    rotate([0,0,hopper_clasp_frill_angular_offset+ang-hopper_clasp_frill_angle/3])
      rotate_extrude(angle=hopper_clasp_frill_angle)
        translate([hopper_clasp_frill_offset-hopper_clasp_frill_rd[0],0,0])
          square([2*hopper_clasp_frill_rd[0],hopper_clasp_frill_rd[1]]);

    // mount hole cutout
    rotate([0,0,hopper_clasp_hole_angular_offset+ang])
      translate([hopper_clasp_hole_offset,0,0])
        cylinder(r=hopper_clasp_hole_r, h=hopper_clasp_hole_d);
  }
}

module hopper_pos()
{
  // spherical part of hopper
  intersection()
  {
    cylinder(r=hopper_od/2, h=hopper_od/2);
    translate([0,0,hopper_od/2])
    {
      sphere(r=hopper_od/2);
    }
  }

  // cylindrical part of hopper
  translate([0,0,hopper_od/2])
  {
    cylinder(r=hopper_od/2, h=hopper_total_h-hopper_clasp_od/2);
  }

  // hopper attachment point:
  cylinder(r=hopper_clasp_od/2, h=max(hopper_clasp_h,hopper_clasp_od/2));
}


// Conventions:
// * When an object is rendered using partname, position/rotate it according to
//   printing suggestion, here. (The module itself will be positioned/rotated
//   like it will be, in the put-together "display" situation.)
// * The special value "display" for partname is the product picture for all
//   parts put together.
if ("display" == partname)
{
  hopper();
} else if ("hopper" == partname)
{
  hopper();
}
