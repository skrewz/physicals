// Use partname to control which object is being rendered:
//
// _partname_values wall_mounted_clasp wall_plate mount_for_3m_adhesive_cover shelf_mounted_clasp
partname = "display";

// generic thickness of walls, as used here and there:
wall_thickness = 2;
// a special wall; the piece that extends from the quickmount to the business end:
wall_mount_offset_thickness = 4;

// a special wall; the width between the camera screw and the base station
// (set this depending on how long your screw is)
screw_wall_thickness = 5;

// a special wall; the edges of the "cover" inserts for the 3m hook gaps in wall_plate().
mount_for_3m_adhesive_cover_thickness = 1;

base_station_grabber_strip_width = 10;

wall_mount_wh = [90,90];
wall_mount_thickness = 11;
// minimum offset from wall to reach beyond obstacles (blackout curtains):
wall_mount_offset_length = 90;
// not a rectangular room? lower than 90 opens the mount further:
wall_mount_offset_angle = 90-20;
// down angle from pointing straight outwards; should be mounted above eye level and pointed downwards:
wall_mount_base_station_off_mount_rotation = [-20,0,-20];

shelf_beam_cutout_wd = [16.3,16.3];
// how much of a beam to grab onto:
shelf_beam_grab_length = 60;
shelf_beam_lip_size = 1.5;
shelf_screwmount_height = 35;
shelf_screwmount_rotation = [-90-20,0,20];
shelf_screw_clearance_height = 20;




// height over feet to extend the base rim (i.e. how deep the cutout the base
// stands in is):
//
// On choosing this: the non-stick bottom coating is roughly 2mm tall, so one
// wants to get clear of that.
base_station_rim_height = 4;

/*
 * physically conditioned constants
 */

base_rear_width = 69;
base_rear_height = 77;
base_front_width = 75;
base_front_height = 79;
// from front of circular part to flat back, same at front and back (phew)
base_depth = 63;
// from where circular part begins to flat back; not length of side
base_depth_noncircular = 45;
// can't say this was directly measured, but close enough:
base_circle_radius = 48;

// from bottom to center of plug:
base_power_inlet_height = 28.5;
// from left side (as seen from the back) to center of plug:
base_power_inlet_inset = 18;
// the radius to clear for the plug:
base_power_inlet_clearance_radius = 4.5;
// from the flat back to the height of the clearance cylinder:
base_power_inlet_clearance_height = 4;


// screwthrad is centered; how high from base of bottom?
base_screwthread_height = 52;
screwthread_radius = 3.4;
screw_head_radius = 10+1; // real radius is 20mm, give or take
wall_mount_screw_clearance_height = 21;

wall_mount_screwmount_height = 30;

/*
 * arbitrary internal assignments
 */

mount_for_3m_adhesive_wdh = [25,3,62];
base_station_top_angle = atan((base_front_height-base_rear_height)/base_depth);

pyramid_slot_height=30;
// first is bottom square side length, second is top square side length:
pyramid_slot_sidelengths=[4,7];
pyramid_slot_height_difference = 55;
pyramid_slot_excavation_sidelength = pyramid_slot_sidelengths[1]+2*0.5;
pyramid_entry_angle = 10;

// relative to the wall_mount_thickness and wall_mount_offset_length, how far
// before the clasp is clear of wall_mount()?
wall_mount_clearance_before_clasp_solids = wall_mount_thickness;



wall_mount_pyramid_positions = [
  [
    wall_mount_wh[0]-wall_mount_thickness,
    wall_thickness+pyramid_slot_sidelengths[1]/2,
    wall_mount_wh[1]-pyramid_slot_height-pyramid_slot_height_difference
  ],
  [
    wall_mount_wh[0]-wall_mount_thickness,
    wall_thickness+pyramid_slot_sidelengths[1]/2,
    wall_mount_wh[1]-pyramid_slot_height
  ]
];

wall_mount_pyramid_rotation = [
      0,
      pyramid_entry_angle,
      wall_mount_offset_angle];

/*
 * modules
 */


// hold this one against the xz plane:
module camera_screw_thread_mount(rotation,screwmount_height,screw_clearance_height)
{
  intersection()
  {
    // cut to only stuff y-positive of the the xz plane:
    translate([-200/2,0,-200/2])
      cube([200,200,200]);
    rotate(rotation)
    {
      difference()
      {
        // a cylindrical extension towards the screwthread
        union()
        {
          cylinder(
            r=screw_head_radius+2*wall_thickness,
            h=screwmount_height+wall_thickness
          );
          sphere(r=screw_head_radius+2*wall_thickness);
        }
        translate([
          -screw_head_radius,
          -2*screw_head_radius,
          screwmount_height-screw_wall_thickness-screw_clearance_height
        ]) {
          cube([2*screw_head_radius,4*screw_head_radius,screw_clearance_height]);
        }
        translate([0,0,(screwmount_height-screw_clearance_height)])
        cylinder(r=screwthread_radius,h=2*screw_clearance_height,$fs=0.3);
      }
    }
  }
}

module mount_for_3m_adhesive_pos ()
{
  render()
  {
    intersection()
    {
      cube(mount_for_3m_adhesive_wdh);
      translate([12.5,0,16.8])
        mirror([0,0,1])
        import("imports/Index_Wall_Bracket.stl");
    }
  }
}
module mount_for_3m_adhesive_neg ()
{
  render()
  {
    difference()
    {
      translate([0.01,0.01,0.01])
        cube(mount_for_3m_adhesive_wdh-[0.02,0.02,0.02]);
      mount_for_3m_adhesive_pos();
    }
  }
}
module base_station_bottom_2d_profile()
{
  polygon([
    [-base_rear_width/2, 0],
    [base_rear_width/2, 0],
    [base_front_width/2, base_depth_noncircular],
    [-base_front_width/2, base_depth_noncircular],
  ]);
  intersection()
  {
    translate([-base_front_width/2,base_depth_noncircular])
      square([base_front_width,base_depth-base_depth_noncircular]);
    translate([0,base_depth-base_circle_radius,0])
      circle(r=base_circle_radius);
  }
}
module base_station()
{
  % color([0.4,0.4,0.4,0.7])
  {
    translate([-base_rear_width/2,0,0])
    {
      // at this point, at bottom left of back of case, where the measurements apply:
      translate([base_power_inlet_inset,0,base_power_inlet_height])
      {
        // the plug cylinder clearance itself:
        rotate([90,0,0])
          cylinder(r=base_power_inlet_clearance_radius,h=base_power_inlet_clearance_height);

        // the plug itself:
        translate([0,-base_power_inlet_clearance_height-base_power_inlet_clearance_radius,0])
        {
          translate([0,0,-20])
            cylinder(r=base_power_inlet_clearance_radius,h=20+base_power_inlet_clearance_radius);
        }

      }
    }
  }
  % color([0,0,0,0.7])
  {
    difference()
    {
      linear_extrude(height = base_front_height)
      {
        base_station_bottom_2d_profile();
      }
      translate([-base_front_width/2,0,base_rear_height])
        rotate([base_station_top_angle,0,0])
          cube([base_front_width,base_depth,base_front_height]);
    }
  }
  % color([0.9,0.9,0.9,0.7])
  {
    translate([0,0,base_screwthread_height])
      rotate([90,0,0])
        cylinder(r=screwthread_radius,h=10);
  }
}
module clasp_for_base_station ()
{
  scale_factor = (2*wall_thickness+base_front_width)/base_front_width;
  // floorplate, with cutout for base station to stand in:
  difference()
  {
    linear_extrude(height = wall_thickness+base_station_rim_height)
    {
      scale(scale_factor)
        base_station_bottom_2d_profile();
    }
    translate([0,0,wall_thickness])
    {
      linear_extrude(height = (wall_thickness+base_station_rim_height)+/*get off:*/wall_thickness)
      {
        scale(0.97*scale_factor)
          base_station_bottom_2d_profile();
      }
    }
  }
  // back wall (FIXME: could be triangular-esque?)
  difference()
  {
    translate([0,0,wall_thickness])
    {
      linear_extrude(height = base_rear_height + wall_thickness)
      {
        scale([scale_factor,1,1])
          translate([-base_rear_width/2,0])
            square([base_rear_width,wall_thickness]);
      }
    }
    translate([-base_rear_width/2,2*wall_thickness,0])
    {
      // at this point, at bottom left of back of case, where the measurements apply:
      translate([base_power_inlet_inset,0,base_power_inlet_height])
        rotate([90,0,0])
          cylinder(r=base_power_inlet_clearance_radius,h=3*wall_thickness);
    }

  }
  // grabber for front of base station:
  grabber_length = wall_thickness + base_depth/cos(base_station_top_angle);
  translate([0,0,wall_thickness + base_rear_height])
    translate([0,wall_thickness,0])
      rotate([base_station_top_angle,0,0])
      {
        translate([-base_station_grabber_strip_width/2,0,0])
          cube([base_station_grabber_strip_width,grabber_length,wall_thickness]);
        // reinforcement rib:
        translate([-wall_thickness/2,0,0])
          cube([wall_thickness,grabber_length,2*wall_thickness]);
        // now, "go there", to the end of the grabber, and place some downward wall:
        translate([0,grabber_length-wall_thickness,-2*wall_thickness])
          translate([-base_station_grabber_strip_width/2,0,0])
            cube([base_station_grabber_strip_width,wall_thickness,2*wall_thickness]);
      }
}

module pyramid_slot()
{

  linear_extrude(
    height = pyramid_slot_height,
    scale=(pyramid_slot_sidelengths[1]/pyramid_slot_sidelengths[0]))
  {
    translate([-pyramid_slot_sidelengths[0]/2,-pyramid_slot_sidelengths[0]/2])
      square([pyramid_slot_sidelengths[0],pyramid_slot_sidelengths[0]]);
  }
}

module pyramid_slot_excavation()
{
  pyramid_slot();

  translate([
    -pyramid_slot_excavation_sidelength/2,
    -pyramid_slot_excavation_sidelength/2,
    pyramid_slot_height-0.01]
  ){
    // the idea is to provide a slide-in track of pyramid_slot_height length,
    // but to ensure that cuts loose, double it:
      cube([pyramid_slot_height,pyramid_slot_excavation_sidelength,2*pyramid_slot_height]);
  }
}

// To mount semi-permanently to wall:
module wall_plate()
{
  module rounded_plate(width, height, radius)
  {
    intersection()
    {
      translate([radius,0,radius])
      {
        minkowski()
        {
          sphere(r=radius);
          cube([
            width-2*radius,
            0.01,
            height-2*radius]);
        }
      }
      cube([width,radius,height]);
    }
  }
  mount_for_3m_adhesive_xoffs = [
    2*wall_mount_wh[0]/9-mount_for_3m_adhesive_wdh[0]/2,
    6*wall_mount_wh[0]/9-mount_for_3m_adhesive_wdh[0]/2
  ];
  mount_for_3m_adhesive_height =
    wall_mount_wh[1]-1*wall_mount_thickness-mount_for_3m_adhesive_wdh[2];


  // base plate sans:
  difference()
  {
    union()
    {
      rounded_plate(wall_mount_wh[0],wall_mount_wh[1],wall_mount_thickness);
    }
    // * cutouts to place 3m adhesive attachments into:
    for (xoff=mount_for_3m_adhesive_xoffs)
    {
      translate([xoff, -0.01, mount_for_3m_adhesive_height])
        cube(mount_for_3m_adhesive_wdh+[0,wall_mount_thickness,0]);
    }
    // * quick-attach pyramid slot
    for (wall_mount_pyramid_position=wall_mount_pyramid_positions)
      translate(wall_mount_pyramid_position)
        rotate(wall_mount_pyramid_rotation)
          pyramid_slot_excavation();
  }

  for (xoff=mount_for_3m_adhesive_xoffs)
  {
    translate([xoff, -0.01, mount_for_3m_adhesive_height])
      mount_for_3m_adhesive_pos();
  }
}

// Using clasp_for_base_station() to fit with wall_plate():
// centers on (and rotates according to) the bottom of its pyramid_slot():
module wall_mounted_clasp()
{
  // the pyramid_slot hooks themselves:

  for (zoff=[0,pyramid_slot_height_difference])
  {
    translate([0,pyramid_slot_sidelengths[1]/2,zoff])
    {
      translate([
        -sin(pyramid_entry_angle)*pyramid_slot_height,
        0,
        sin(pyramid_entry_angle)*pyramid_slot_sidelengths[1]
      ]){
        rotate([0,pyramid_entry_angle,0])
        {
          pyramid_slot();
          translate([-pyramid_slot_sidelengths[1]/2,-pyramid_slot_sidelengths[1]/2,pyramid_slot_height])
          {
            cube([pyramid_slot_sidelengths[1],pyramid_slot_sidelengths[1],pyramid_slot_sidelengths[1]]);
          }
        }
      }
      translate([
        -pyramid_slot_sidelengths[1]/2,
        -pyramid_slot_sidelengths[1]/2,
        pyramid_slot_height]
      ){
        linear_extrude(height = pyramid_slot_sidelengths[1])
        {
          polygon([
            [pyramid_slot_sidelengths[1]/2,0],
            [pyramid_slot_sidelengths[1]/2,pyramid_slot_sidelengths[1]],
            [pyramid_slot_sidelengths[1],pyramid_slot_sidelengths[1]],
            [2.5*pyramid_slot_sidelengths[1],wall_thickness],
            [2.5*pyramid_slot_sidelengths[1],0],
          ]);
        }
      }
    }
  }
  // the span between the outriggers created by the hooks:
  hull()
  {
    for (zoff=[0,pyramid_slot_height_difference])
    {
      translate([wall_mount_clearance_before_clasp_solids,0,zoff])
      {
        translate([
          -pyramid_slot_sidelengths[1]/2,
          0,
          pyramid_slot_height]
        ){
          cube([
            pyramid_slot_sidelengths[1],
            wall_mount_offset_thickness,
            pyramid_slot_sidelengths[1]]
          );
        }
      }
    }
    // mount for where the business end of the mount goes
    translate([
      wall_mount_offset_length+base_rear_width/2,
      0,
      pyramid_slot_height+(pyramid_slot_height_difference/2)
    ]){
      rotate([-90,0,0])
        cylinder(r=pyramid_slot_sidelengths[1]/2,h=wall_mount_offset_thickness);

    }
  }
  translate([
    wall_mount_offset_length+base_rear_width/2,
    0,
    pyramid_slot_height+(pyramid_slot_height_difference/2)
  ]) {
    camera_screw_thread_mount(
      wall_mount_base_station_off_mount_rotation-[90,0,0],
      wall_mount_screwmount_height,
      wall_mount_screw_clearance_height
    );
  }


  // base station mounting:
  translate([
    wall_mount_offset_length+base_rear_width/2,
    0,
    0,
  ]){
    rotate(wall_mount_base_station_off_mount_rotation)
      base_station();
  }
}

module shelf_mount()
{
  difference()
  {
    cube([
      shelf_beam_grab_length,
      shelf_beam_cutout_wd[1]+2*wall_thickness,
      shelf_beam_grab_length]);

    translate([
      -shelf_beam_grab_length,
      -0.01,
      shelf_beam_grab_length-(shelf_beam_cutout_wd[0]+wall_thickness)
    ]){
      // The horizontal beam cutout:
      cube([
      3*shelf_beam_grab_length, // cut through it all
      shelf_beam_cutout_wd[1]+wall_thickness,
      shelf_beam_cutout_wd[0]]);
    }

    translate([
      shelf_beam_grab_length-shelf_beam_cutout_wd[0]-wall_thickness,
      wall_thickness,
      -0.01
    ]) {
      // The vertical beam cutout
      cube([shelf_beam_cutout_wd[0],shelf_beam_cutout_wd[1],shelf_beam_grab_length-wall_thickness]);
      // The vertical beam cutout's cutting free (but with clip-on lips)
      translate([shelf_beam_lip_size,-2*wall_thickness,0])
      {
        cube([
          shelf_beam_cutout_wd[0]-2*shelf_beam_lip_size,
          3*wall_thickness,
          shelf_beam_grab_length-wall_thickness
        ]);
      }
    }
  }
}

module shelf_mount_thread_mount()
{
  translate([
    (shelf_beam_grab_length-shelf_beam_cutout_wd[0])/2,
    0,
    (shelf_beam_grab_length-shelf_beam_cutout_wd[1])/2
  ]) {
    mirror([0,1,0])
    {
      camera_screw_thread_mount(
      shelf_screwmount_rotation,
      shelf_screwmount_height,
      shelf_screw_clearance_height
      );
    }
  }
}
module shelf_mounted_clasp()
{
  shelf_mount();
  shelf_mount_thread_mount();
}

module mount_for_3m_adhesive_cover()
{
  // by how much this cover (which slots into a gap) should be undersized
  // from said gap:
  shrink_amount = 0.3;

  outer_wdh = [
    mount_for_3m_adhesive_wdh[0]-shrink_amount,
    wall_mount_thickness-mount_for_3m_adhesive_wdh[1]-wall_thickness,
    mount_for_3m_adhesive_wdh[2]-shrink_amount
  ];



  difference()
  {
    cube(outer_wdh);
    translate([
      mount_for_3m_adhesive_cover_thickness,
      -mount_for_3m_adhesive_cover_thickness,
      mount_for_3m_adhesive_cover_thickness
    ]) {
      cube([
        outer_wdh[0]-2*mount_for_3m_adhesive_cover_thickness,
        outer_wdh[1],
        outer_wdh[2]-2*mount_for_3m_adhesive_cover_thickness
      ]);
    }
  }
}
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 12;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 2;


// Conventions:
// * When an object is rendered using partname, position/rotate it according to
//   printing suggestion, here. (The module itself will be positioned/rotated
//   like it will be, in the put-together "display" situation.)
// * The special value "display" for partname is the product picture for all
//   parts put together.
if ("display" == partname)
{

  // Note: offsets in the composition of partname=display are hardwired and may
  // not follow (changes to) parameter values neatly.
  //
  // The submodules are often self-relatively specified, and with no need to
  // fit into the grander scheme of things. Thus, these are mere "looks about
  // right" settings, for the look of things.

  translate([0,wall_mount_wh[0],0])
    rotate([0,0,-90])
      wall_plate();
  translate([20,0,20])
    rotate([0,0,wall_mount_offset_angle-90])
      wall_mounted_clasp();

  for (xoff = [42,82])
    translate([20,xoff,20])
      rotate([0,0,-90])
        mount_for_3m_adhesive_cover();

  translate([0,200,0])
    rotate([0,0,90])
    shelf_mounted_clasp ();


} else if ("wall_mounted_clasp" == partname)
{
  rotate([90,0,0])
  {
    wall_mounted_clasp();
  }
} else if ("wall_plate" == partname)
{
  rotate([90,0,0])
  {
    wall_plate();
  }
} else if ("mount_for_3m_adhesive_cover" == partname)
{
  rotate([90,0,0])
  {
    mount_for_3m_adhesive_cover();
  }
} else if ("shelf_mounted_clasp" == partname)
{
  rotate([-90,0,00])
    shelf_mounted_clasp ();
}
