// Use partname to control which object is being rendered:
//
// _partname_values bottom_of_screen_mount phone_mount grabber cable_clasp monolith_screen_mount
partname = "display";

include <libs/compass.scad>
include <threadlib/threadlib.scad>

// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;


// Dimensions of actual phone+cover with a bit of clearance:
//
// - phone_wdh[2] isn't actually used in this model as of this writing.
// - phone_wdh[0] should probably be 1-2 mm more than the actual size.
// - Getting phone_wdh[1] correctly calibrated is key to the model being smooth
//   to use. Too tight and it'll hinder insertion, too loose and it'll make
//   catching the plug inconsistent.
//
// Consider using your slicer to cut the model down to only the part
// immediately surrounding the plug to get this (and plug_wdh) dialed in.

phone_wdh = [78.3/*measured*/ + 1.7,12.3 /*measured*/ + 0.7,160];

// Couple of notes on plug_wdh:
// 
// - Underplay the plug_wdh[2] measurement to have plug pop out above plane.
//   That can be useful to get through covers and ensure the phone stands on
//   its plug
// - Overplay plug_wdh[1] a bit and expect to use spacers during installation.
//   Not all phones have their charging port dead centre in the plug_wdh[1]
//   direction and the model does not compensate for this.

plug_wdh = [13,7.2,24];

// If your cable is flat, you need it at its widest, here (including clearance)
//
// (Not a terribly important measurement to get right; err to the large side.)
plug_cable_r = 5.3;

// For the non-rotating monolith mount, which angle of rotation:
monolith_screen_phone_angle = -20;

// Generic wall width:
wall_width = 3;



// Parameters that generally do not need to be adjusted below:
//
plug_cable_support_h = wall_width;
plug_d_offset = 4;

extra_h_around_grabber = 1;


phone_case_depth=phone_wdh[1]+2*wall_width;
phone_cutout_h = 0.4*phone_wdh[2];
phone_cableholder_height = plug_cable_support_h+plug_wdh[2];

phone_case_r = 0.5*phone_case_depth;

screen_mount_attachment_length_wh=[50,100];


module phone_mount()
{
  difference() {
    phone_mount_pos();
    phone_mount_neg();
  }
}
module phone_mount_pos()
{
  // positive parts of phone mount:
  hull ()
  {
    for (t=[(1)*wall_width,-(phone_wdh[0]+(0+0)*wall_width)])
      translate([t,0.5*phone_case_depth,0]){
        cylinder(r=phone_case_r,h=phone_cutout_h+1*wall_width,$fn=80);
      }
  }
}
module phone_mount_neg(drill_holes = true)
{
  hole_depth = 10;
  if (drill_holes)
    for (h=[-0.01,phone_cutout_h+wall_width+0.01-hole_depth])
      translate([1*wall_width,0.5*phone_case_depth,h])
        cylinder(r=3,h=hole_depth,$fn=40);
  // Negative parts of phone mount:
  translate([-phone_wdh[0]-2*wall_width,0,0]){
    union()
    {
      translate([wall_width,wall_width,phone_cableholder_height])
        cube([
            phone_wdh[0],
            phone_wdh[1],
            phone_wdh[2]]
            );
      translate([
          0.1*phone_wdh[0]+wall_width,
          wall_width,
          phone_cableholder_height])
      {
        cube([
            0.8*phone_wdh[0],
            phone_wdh[1]+10*wall_width,
            phone_wdh[2]]
            );
      }
      /* translate([ */
      /*     0.5*phone_wdh[0]+wall_width-plug_wdh[0]/2, */
      /*     wall_width+plug_d_offset, */
      /*     plug_cable_support_h]) */
      /* { */
      /*   cube([ */
      /*       plug_wdh[0], */
      /*       plug_wdh[1], */
      /*       2*plug_wdh[2]] */
      /*       ); */
      /* } */

      translate([
          0.5*phone_wdh[0]+wall_width-plug_wdh[0]/2,
          wall_width+plug_d_offset,
          plug_cable_support_h])
      {

        mirror([0,1,0])
          translate([
            plug_wdh[0]/2-max(plug_cable_r,plug_wdh[1])/2,
            -1.01*(wall_width+plug_d_offset),
            -1.01*plug_d_offset])
          cube([
              max(plug_cable_r,plug_wdh[1]),
              2*wall_width+phone_wdh[1],
              // adding plug_wdh[0] here ensures it can pass:
              plug_wdh[2]+plug_cable_support_h+plug_wdh[0]]);

        cube([
            plug_wdh[0],
            plug_wdh[1],
            2*plug_wdh[2]]
            );
        // clasp for securing the USB plug in place
        translate([-2*plug_wdh[0],-1*plug_wdh[1],0])
        {
          cube([5*plug_wdh[0],plug_wdh[1],0.5*plug_wdh[2]]);
        }
        for (xoff = [-1*plug_wdh[0], 2*plug_wdh[0]])
        {
          translate([xoff,0,0.25*plug_wdh[2]])
          {
            rotate([-90,0,0])
              tap("M6", turns=5);
          }
        }
      }
    }
  }
}

module cable_clasp ()
{
  difference()
  {
    union()
    {
      translate([0.5*plug_wdh[0],0,0.05*plug_wdh[2]])
        cube([4*plug_wdh[0],0.5*plug_wdh[1],0.4*plug_wdh[2]]);
      translate([(2.5-0.5/2)*plug_wdh[0],0,0.05*plug_wdh[2]])
        cube([0.5*plug_wdh[0],1*plug_wdh[1],0.4*plug_wdh[2]]);
    }
    union()
    {
      for (xoff = [1*plug_wdh[0], 4*plug_wdh[0]])
      {
        translate([xoff,-0.5*plug_wdh[1],0.25*plug_wdh[2]])
        {
          rotate([-90,0,0])
            cylinder(r=6.3/2,h=10,$fn=20);
        }
      }
    }
  }
}

module side_clasp ()
{
  difference() {
    side_clasp_pos();
    side_clasp_neg();
  }

}
module side_clasp_pos ()
{
  // bottom peg and holder:
  union ()
  {
    translate([-phone_case_depth,0,0])
    {
      cylinder(r=2.2,h=10,$fn=30);
      cylinder(r=phone_case_depth/2,h=wall_width);
    }
    translate([-phone_case_depth,-phone_case_depth/2,0])
      cube([phone_case_depth,phone_case_depth,wall_width]);
  }
  // Upper mount
  translate([-phone_case_depth,0,phone_cutout_h+2*wall_width+extra_h_around_grabber])
  {
    difference()
    {
      union()
      {
        cylinder(r=phone_case_depth/2,h=wall_width,$fn=30);
        translate([0,-phone_case_depth/2,0])
          cube([phone_case_depth,phone_case_depth,wall_width]);
      }
      translate([0,0,-0.01])
        cylinder(r=3,h=10,$fn=30);
    }
  }

  // connecting the upper and lower clasps (plus space for the grabber() to lock against into):
  translate([0,-phone_case_depth/2,0])
    cube([wall_width,phone_case_depth,phone_cutout_h+4*wall_width+extra_h_around_grabber]);
}
module side_clasp_neg ()
{
}

module bottom_of_screen_mount()
{
  difference() {
    bottom_of_screen_mount_pos();
    bottom_of_screen_mount_neg();
  }
}
module bottom_of_screen_mount_pos()
{
  side_clasp();

  // Horizontal attachment piece
  translate([0,-phone_case_depth/2,0])
    cube([screen_mount_attachment_length_wh[0],phone_case_depth,wall_width]);

  // Upwards attachment piece
  translate([0,-phone_case_depth/2,0])
    cube([wall_width,phone_case_depth,screen_mount_attachment_length_wh[1]]);
}
module bottom_of_screen_mount_neg()
{
}

module monolith_screen_mount()
{
  difference() {
    monolith_screen_pos();
    monolith_screen_neg();
  }
}
module monolith_screen_pos()
{
  translate([-phone_case_r,0,0])
  {
    rotate([0,0,monolith_screen_phone_angle])
    {
      translate([-1*wall_width,-phone_case_r,0])
      {
        phone_mount_pos();
      }
    }
  }

  // Horizontal attachment piece
  translate([0,-phone_case_depth/2,0])
    cube([screen_mount_attachment_length_wh[0],phone_case_depth,wall_width]);
  hull()
  {
    translate([-phone_case_r,0,0])
      cylinder(r=phone_case_r,h=phone_cutout_h+1*wall_width,$fn=80);
    // Upwards attachment piece
    translate([0,-phone_case_depth/2,0])
      cube([wall_width,phone_case_depth,phone_cutout_h+1*wall_width]);
  }
  // Further upwards attachment piece
  translate([0,-phone_case_depth/2,0])
    cube([wall_width,phone_case_depth,screen_mount_attachment_length_wh[1]]);

}
module monolith_screen_neg()
{
  translate([-phone_case_r,0,0])
  {
    rotate([0,0,monolith_screen_phone_angle])
    {
      translate([-1*wall_width,-phone_case_r,0])
      {
        phone_mount_neg(drill_holes=false);
      }
    }
  }
}

module grabber(h=10+wall_width)
{
  translate([-phone_case_depth,-phone_case_depth/2,0])
    cube([phone_case_depth-0.5,phone_case_depth,wall_width]);
  translate([-phone_case_depth,0,0])
  {
    cylinder(r=2.2,h=h,$fn=30);
  
    cylinder(r=phone_case_depth/2,h=wall_width);
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
  monolith_screen_mount();

  translate([-phone_case_r,0,0])
  {
    rotate([0,0,monolith_screen_phone_angle])
    {
      // I'll be damned if I can place this correctly, but, whatever:
      translate([-3*wall_width-phone_wdh[0]+plug_wdh[0]/2,-2*phone_case_r,0])
      {
        cable_clasp();
      }
    }
  }

  // Rotate this part of the display output to showcase the M6 threaded
  // solution for clasping the plug
  rotate([0,0,180])
  {
    translate([3*phone_wdh[0],0,0])
    {
      bottom_of_screen_mount();
      // Very approximate positioning, whatever:
      translate([-3*wall_width-phone_wdh[0]+plug_wdh[0]/2,-2*phone_case_r,0])
      {
        cable_clasp();
      }
      translate([0,0,4*wall_width+phone_cutout_h+extra_h_around_grabber+1])
      {
        mirror([0,0,1])
        {
          grabber(14);
        }
      }

      translate([-(phone_case_depth+wall_width),-(phone_wdh[1]-1*wall_width),wall_width+extra_h_around_grabber/2])
        phone_mount();
    }
  }

} else if ("phone_mount" == partname)
{
    phone_mount();
} else if ("bottom_of_screen_mount" == partname)
{
    bottom_of_screen_mount();
} else if ("cable_clasp" == partname)
{
    cable_clasp();
} else if ("monolith_screen_mount" == partname)
{
    monolith_screen_mount();
} else if ("grabber" == partname)
{
    grabber();
}
