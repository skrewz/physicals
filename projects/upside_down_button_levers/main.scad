// Use partname to control which object is being rendered:
//
// _partname_values outer_arm inner_arm hinge
partname = "display";

arm_height = 10;
arm_thickness = 2;

// full length roughly 225, and 20 are added for overlap, divided thus:
arm_hinge_overlap = 30;
outer_arm_length = 105+arm_hinge_overlap/2;
inner_arm_length = 120+arm_hinge_overlap/2;

inner_arm_button_presser_depth = 3;

outer_arm_finger_area_inset = 20;
outer_arm_finger_area_width = 10;


// how much off plane level should the hinge lift the arms?
hinge_lift = 4;
hinge_length = 10;
hinge_base_length = 30;
hinge_width = 50;
// how far apart two hinges would be:
hinge_interval = 24;
hinge_arm_spacing = 3*arm_thickness;

m3_bolt_cutout_r = 1.7;

// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 12;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 1;

// internal:
//drillpoints = [1*arm_hinge_overlap/4,2*arm_hinge_overlap/4,3*arm_hinge_overlap/4];
drillpoints = [
  min(0.25*arm_hinge_overlap,3*m3_bolt_cutout_r),
  0.5*arm_hinge_overlap,
  max(0.75*arm_hinge_overlap,arm_hinge_overlap-3*m3_bolt_cutout_r),
];

module outer_arm()
{
  difference()
  {
    union()
    {
      // the finger area:
      translate([outer_arm_finger_area_width/2,0,0])
        cylinder(r=outer_arm_finger_area_width/2, h=arm_thickness);


      // hull()-based extension from finger area to arm:
      // first, a flat boxy piece:
      translate([outer_arm_finger_area_width/2,-outer_arm_finger_area_width/2,0])
        cube([outer_arm_finger_area_width/2,outer_arm_finger_area_width,arm_thickness]);
      hull()
      {
        translate([outer_arm_finger_area_width,-outer_arm_finger_area_width/2,0])
          cube([0.01,outer_arm_finger_area_width,arm_thickness]);
        translate([outer_arm_finger_area_inset,-arm_thickness/2,0])
          cube([0.01,arm_thickness,arm_height]);
      }

      // the arm itself
      translate([outer_arm_finger_area_inset,-arm_thickness/2,0])
        cube([outer_arm_length-outer_arm_finger_area_inset,arm_thickness,arm_height]);

      /* translate([outer_arm_finger_area_width/2,-outer_arm_finger_area_width/2,0]) */
      /*   cube([outer_arm_finger_area_inset-outer_arm_finger_area_width/2+20,outer_arm_finger_area_width,arm_thickness]); */

      /* // the arm itself */
      /* translate([outer_arm_finger_area_inset,-arm_thickness/2,0]) */
      /*   cube([outer_arm_length-outer_arm_finger_area_inset,arm_thickness,arm_height]); */
    }

    translate([outer_arm_length-arm_hinge_overlap,-arm_thickness/2,0])
    {
      for (xoff = drillpoints)
        translate([xoff,0,arm_height/2])
          rotate([-90,0,0])
            translate([0,0,-arm_thickness])
              cylinder(r=m3_bolt_cutout_r,h=3*arm_thickness);
    }
  }
}
module inner_arm()
{
  difference()
  {
    union ()
    {
      translate([0,-arm_thickness/2,0])
        cube([inner_arm_length,arm_thickness,arm_height]);
      translate([inner_arm_length,-arm_thickness/2,0])
        rotate([0,180+45,0])
          cube ([inner_arm_button_presser_depth/cos(45), arm_thickness,inner_arm_button_presser_depth/cos(45)]);
    }
    translate([0,-arm_thickness/2,0])
    {
      for (xoff = drillpoints)
        translate([xoff,0,arm_height/2])
          rotate([-90,0,0])
            translate([0,0,-arm_thickness])
              cylinder(r=m3_bolt_cutout_r,h=3*arm_thickness);
    }
  }
}
module hinge()
{
  translate([-(hinge_base_length-hinge_length)/2,0,0])
    cube([hinge_base_length,hinge_width,arm_thickness]);

  // the left-or-right distance from an arm's centerline:
  yoff_dist = (hinge_arm_spacing+2*0.5*arm_thickness)/2;
  // the hinge rotation points
  difference ()
  {
    union ()
    {
      for (hinge_pos = [
        hinge_width/2-hinge_interval/2,
        hinge_width/2+hinge_interval/2
      ])
        for (yoff = [
          hinge_pos-yoff_dist,
          hinge_pos+yoff_dist
        ])
          translate([0,yoff-0.5*arm_thickness,0])
            cube([hinge_length,arm_thickness,hinge_lift+arm_height]);
    }
    translate([hinge_length/2,0,hinge_lift+arm_height/2])
      rotate([-90,0,0])
        cylinder(r=m3_bolt_cutout_r,h=hinge_width);
    }
}


// Conventions:
// * When an object is rendered using partname, position/rotate it according to
//   printing suggestion, here. (The module itself will be positioned/rotated
//   like it will be, in the put-together "display" situation.)
// * The special value "display" for partname is the product picture for all
//   parts put together.
module assembled_arm ()
{
  translate([0,0,hinge_lift])
    outer_arm();
  translate([outer_arm_length-arm_hinge_overlap,arm_thickness,hinge_lift])
    inner_arm();
}
if ("display" == partname) {
  for (yoff = [-hinge_interval/2,hinge_interval/2])
    translate([0,yoff,0])
      assembled_arm();
  translate([
    outer_arm_length-arm_hinge_overlap/2-(hinge_length/2),
    -(hinge_width/2-0.5*arm_thickness),
    0
  ]) {
    hinge();
  }
} else if ("outer_arm" == partname) {
  outer_arm();
} else if ("inner_arm" == partname) {
  rotate([90,0,0])
  {
    inner_arm();
  }
} else if ("hinge" == partname) {
  hinge();
}
