// Use partname to control which object is being rendered:
//
// _partname_values mount
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 1;

support_length = 30;
support_wall_thickness = 3;
brace_thickness = 6;
// the wall that gets squeezed in place:
wedge_wall_thickness = 1;
past_wedge_l_size = 3;
// size of metal profile
profile_cutout_dh = [16.5,16.5];

strap_rest_radius = 6;
strap_rest_width = 50;
strap_rest_gap_size = 7;


module mount()
{
  difference()
  {
    linear_extrude(height=brace_thickness+strap_rest_width+brace_thickness)
    {
      polygon([
        [0,0],
        [support_length,0],
        [support_length+profile_cutout_dh[0]+wedge_wall_thickness,0],
        // construct the L:
        [support_length+profile_cutout_dh[0]+wedge_wall_thickness,-wedge_wall_thickness/2],
        [support_length+profile_cutout_dh[0]+wedge_wall_thickness,-past_wedge_l_size-wedge_wall_thickness/2],
        [support_length+profile_cutout_dh[0],                     -past_wedge_l_size-wedge_wall_thickness/2],

        // back to wedge itself:
        [support_length+profile_cutout_dh[0],-wedge_wall_thickness],

        // work around the profile:
        [support_length,                       -wedge_wall_thickness],
        [support_length,                       -profile_cutout_dh[1]-wedge_wall_thickness],
        // work past it with an eye to insertion spacing:
        [support_length+2*profile_cutout_dh[0],-profile_cutout_dh[1]-wedge_wall_thickness],

        // add square base for cylinder to extend from:
        [support_length+2*profile_cutout_dh[0],-profile_cutout_dh[1]-wedge_wall_thickness+strap_rest_radius],
        [support_length+2*profile_cutout_dh[0]+2*strap_rest_radius,-profile_cutout_dh[1]-wedge_wall_thickness+strap_rest_radius],
        [support_length+2*profile_cutout_dh[0]+2*strap_rest_radius,-profile_cutout_dh[1]-wedge_wall_thickness-brace_thickness],
        // back at profile cutout:
        [support_length+profile_cutout_dh[0],-profile_cutout_dh[1]-wedge_wall_thickness-brace_thickness],
        [support_length,-profile_cutout_dh[1]-wedge_wall_thickness-brace_thickness],
      ]);
    }
    translate([
      // let's get "far enough" away from the profile:
      support_length+1.5*profile_cutout_dh[0],
      -profile_cutout_dh[1]-brace_thickness-wedge_wall_thickness-0.01,
      brace_thickness
    ]){

      cube ([2*2*strap_rest_radius,2*2*strap_rest_radius,strap_rest_width+0.02]);
    }

  }

  // two-part cylinder with ball endings:
  full_height = brace_thickness+strap_rest_width+brace_thickness;
  module column ()
  {
    cylinder(r=strap_rest_radius,h=(full_height-(strap_rest_gap_size+2*strap_rest_radius))/2);
    translate([0,0,(full_height-(strap_rest_gap_size+2*strap_rest_radius))/2])
      sphere(r=strap_rest_radius);
  }
  translate([
    support_length+2*profile_cutout_dh[0]+strap_rest_radius,
    -profile_cutout_dh[1]-wedge_wall_thickness+strap_rest_radius,
    0
  ]) {

    column();
    translate([0,0,full_height])
      mirror([0,0,1])
        column();
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
  mount();
} else if ("mount" == partname)
{
  mount();
}
