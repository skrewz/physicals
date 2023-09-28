// Use partname to control which object is being rendered:
//
// _partname_values stand worm_drive container_holder
partname = "display";

include <libs/compass.scad>
include <libs/gears.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;


gear_teeth = 60;
gear_width = 5;

// Salsa dip container circumference/height: 271mm/77mm
container_rh = [271/(3.1415*2), 77+2];


motor_axle_offset = [7, container_rh[1]/2];
stand_wdh = [3*container_rh[0], 1.7*gear_teeth, 0];

motor_mount_r_scale_factor = 1.1;

wall_w = 2;
stand_wall_w = 3;



m3_radius=1.6;
m3_cap_radius=2.6;
m3_cap_clear_height=1.7;
// the width of a nut, if we're making cutouts for it:
m3_nut_width=6;
m3_nut_height_cutout=4;

motor_length=17;
motor_gearing_length=9;
motor_gearing_width=12;
motor_gearing_height=10;
motor_rear_clearance=2;
motor_diameter=12;
motor_flattened_height=10;
motor_axle_protrusion=9;
motor_axle_clearing=1; // length above gearbox
motor_axle_diameter=3;
motor_axle_flattened_diameter=2.5;

offset_for_gear = 1*gear_teeth/2;

bottle_holder_axle_offset_xyz = [
  motor_axle_offset[0]-gear_width/2,
  motor_length+motor_gearing_length+1.4*offset_for_gear,
  offset_for_gear+motor_axle_offset[1]+6
];


free_moving_axle_r = 4;
free_moving_axle_bearing_oversize = 0.7;
axle_bearing_wd = [2*motor_axle_offset[0],2*stand_wall_w];

bottle_holder_length = stand_wdh[0]-motor_axle_offset[0]+gear_width/2;
bottle_holder_axle_r = free_moving_axle_r+wall_w;

bottle_axis_bearing_offsets = [
    gear_width+5,
    bottle_holder_length-axle_bearing_wd[1],
];

module motor_axle ()
{
  intersection(){
    cylinder(r=motor_axle_diameter/2,h=motor_axle_protrusion,$fn=40);

    translate ([-motor_axle_diameter/2,-motor_axle_diameter/2,(/*ccf*/-0.01)*motor_axle_protrusion])
      cube(size=[motor_axle_diameter,motor_axle_flattened_diameter,motor_axle_protrusion*1.02]);
  }
}

module motor ()
{
  // The motor itself:
  union () {
    color("grey")
      intersection(){
        cylinder(r=motor_diameter/2,h=motor_length);
        translate ([-motor_gearing_width/2,-motor_gearing_height/2,0])
          cube(size=[motor_gearing_width,motor_gearing_height,motor_length]);
      }
    // The gearing mechanism:
    color("yellow")
      translate([0,0,(/*ccf*/0.99)*motor_length])
      translate ([-motor_gearing_width/2,-motor_gearing_height/2,0])
      cube(size=[motor_gearing_width,motor_gearing_height,motor_gearing_length]);
    // The axle:
    color("silver")
      translate([0,0,(/*ccf*/0.98)*(motor_length+motor_gearing_length)])
      motor_axle();
  }
}

module stand()
{
  module axle_bearing (radius_height, closed=false)
  {
    translate([-axle_bearing_wd[0]/2,0,0])
    {
      difference()
      {
      #
        cube([axle_bearing_wd[0],axle_bearing_wd[1],radius_height+2*free_moving_axle_r]);
        translate([motor_axle_offset[0],0,radius_height])
        {
          rotate([90,0,0])
          {
            translate([0,0,-2*stand_wall_w])
            {
              if (closed)
              {
                cylinder(r=free_moving_axle_bearing_oversize + free_moving_axle_r,h=3*stand_wall_w);
              }
              else
              {
                hull ()
                {
                  cylinder(r=free_moving_axle_bearing_oversize + free_moving_axle_r,h=3*stand_wall_w);
                  translate([0,2*free_moving_axle_r,0])
                  {
                    cylinder(r=free_moving_axle_bearing_oversize + free_moving_axle_r,h=3*stand_wall_w);
                  }
                }
              }
            }
          }
        }
      }
    }
  }
  
  cube([axle_bearing_wd[0],stand_wdh[1],stand_wall_w]);
  translate([
   0, 
   bottle_holder_axle_offset_xyz[1]-axle_bearing_wd[0]/2, 
   0, 
  ]) {
    cube([stand_wdh[0],axle_bearing_wd[0],stand_wall_w]);
  }
  /* cube([stand_wdh[0],stand_wdh[1],stand_wall_w]); */

  translate([0,0,stand_wall_w])
  {
    motor_mount();
  }

  translate([motor_axle_offset[0],stand_wdh[1]-axle_bearing_wd[1],stand_wall_w])
  {
    axle_bearing(motor_axle_offset[1], true);
  }

  // Bottle axis bearings:
  for (xoff = bottle_axis_bearing_offsets)
  {
    translate([
      xoff+bottle_holder_axle_offset_xyz[0],
      bottle_holder_axle_offset_xyz[1],
      0,
    ]){
      rotate([0,0,-90])
      {
        axle_bearing(bottle_holder_axle_offset_xyz[2]);
      }
    }
  }
}

module motor_mount()
{
  difference()
  {
    cube([
      2*motor_axle_offset[0],
      motor_length,
      motor_gearing_width/2+motor_axle_offset[1]]
    );
    translate([motor_axle_offset[0],0,motor_axle_offset[1]])
    {
      rotate([-90,0,0])
      {
        rotate([0,0,90])
        {
          intersection()
          {
            cylinder(r=motor_mount_r_scale_factor*motor_diameter/2,h=motor_length);
            translate([
              -motor_mount_r_scale_factor*motor_gearing_width/2,
              -motor_mount_r_scale_factor*motor_gearing_height/2,
              0]){
              cube([
                motor_mount_r_scale_factor*motor_gearing_width,
                motor_mount_r_scale_factor*motor_gearing_height,
                motor_mount_r_scale_factor*motor_length]);
            }
          }
          translate([
            -motor_mount_r_scale_factor*motor_gearing_width,
            -motor_mount_r_scale_factor*motor_gearing_height/2,
            0]){
            cube([
              motor_mount_r_scale_factor*motor_gearing_width,
              motor_mount_r_scale_factor*motor_gearing_height,
              motor_mount_r_scale_factor*motor_length]);
          }
          %
          motor();
        }
      }
    }
  }
}

module container_holder ()
{

  // Gear part:
  difference()
  {
    stirnrad (1, gear_teeth, gear_width, 0, 10, bottle_holder_axle_r, 20, -8, optimized);
    for (angle = [0:60:360])
    {
      rotate([0,0,angle])
      {
        translate([3*offset_for_gear/5,0,-0.01])
        {
          cylinder(r=0.25*offset_for_gear, h=gear_width+0.02);
        }
      }
    }
    // elephant's foot compensation:
    difference()
    {
      cylinder(r=offset_for_gear+2, h=0.2*gear_width);
      cylinder(r1=offset_for_gear-2, r2=offset_for_gear+2, h=0.2*gear_width);
    }
    // visually doing the same for the top part:
    translate([0,0,0.8*gear_width])
    {
      difference()
      {
        cylinder(r=offset_for_gear+2, h=0.2*gear_width);
        cylinder(r1=offset_for_gear+2, r2=offset_for_gear-2, h=0.2*gear_width);
      }
    }
  }

  spacing_before_axle_bearing = gear_width/7;

  difference()
  {
    union()
    {
      cylinder(r=bottle_holder_axle_r,h=bottle_holder_length);
      // Place bearing piece on far side:
      cylinder(r=free_moving_axle_r,h=bottle_holder_length+axle_bearing_wd[1]);

      translate([0,container_rh[1]/2,bottle_holder_length-container_rh[0]-wall_w-7])
      {
        rotate([90,0,0])
        {
          difference()
          {
            translate([0,0,-wall_w])
            {
              cylinder(r=container_rh[0]+wall_w,h=container_rh[1]+2*wall_w);
            }
            translate([-(container_rh[0]+wall_w),-(container_rh[0]+wall_w),-wall_w-0.01])
            {
              cube([container_rh[0]+2*wall_w-bottle_holder_axle_r,2*container_rh[0]+2*wall_w,container_rh[1]+2*wall_w+0.02]);
            }
          }
        }
      }
    }
    // Cut out donuts worth of bearing space where relevant:
    for (zoff = bottle_axis_bearing_offsets)
    {
      translate([0,0,zoff-spacing_before_axle_bearing])
      {
        difference()
        {
          cylinder(r=bottle_holder_axle_r+1,h=axle_bearing_wd[1]+2*spacing_before_axle_bearing);
          cylinder(r=free_moving_axle_r,h=axle_bearing_wd[1]+2*spacing_before_axle_bearing);
        }
      }
    }
    translate([0,container_rh[1]/2,bottle_holder_length-container_rh[0]-wall_w-7])
    {
      rotate([90,0,0])
      {
        translate([0,0,-0.01])
        {
          cylinder(r=container_rh[0],h=container_rh[1]+0.02);
        }
        translate([0,0,-wall_w-0.01])
        {
          cylinder(r=container_rh[0]-2*wall_w,h=container_rh[1]+2*wall_w+0.02);
        }
      }
    }
  }
}

module worm_drive ()
{
  gangzahl=1; //worm_starts;
  breite=width;
  laenge=stand_wdh[1]-motor_length-motor_gearing_length-2;
  bohrung_schnecke=3; //worm_bore;
  bohrung_rad=bore;
  nabendicke=final_hub_thickness;
  nabendurchmesser=6; //final_hub_diameter;
  eingriffswinkel=20; //pressure_angle;
  steigungswinkel=8; //lead_angle;
  zusammen_gebaut=true; //true;

  motor_clamp_r = 4+m3_nut_height_cutout;

  rotate([-90,0,0])
  {
    // Flange for avoiding overshooting the gear:
    translate([0,0,laenge-7])
    {
      cylinder(r1=free_moving_axle_r, r2=free_moving_axle_bearing_oversize+free_moving_axle_r+2,h=2);
    }
    translate([0,0,laenge-7])
    {
      cylinder(r=free_moving_axle_r,h=10);
    }
    difference()
    {
      cylinder(r=motor_clamp_r,h=7);

      // motor axle:
      translate([0,0,-0.01])
      {
        // elephant foot clearing
        cylinder(r1=1.5*motor_axle_diameter/2, r2=motor_axle_diameter/2, h=0.5);
        cylinder(r=motor_axle_diameter/2,h=2+motor_axle_protrusion);
      }

      // clamp-down on motor axle:
      translate([0,0,m3_nut_width/2])
      {
        rotate([-90,0,0])
        {
          cylinder(r=m3_cap_radius,h=m3_cap_clear_height);
        }
        rotate([-90,0,0])
        {
          cylinder(r=m3_radius,h=motor_clamp_r);
        }
      }
      // nut holder for clamp-down:
      translate([-m3_nut_width/2,motor_clamp_r/2-m3_nut_height_cutout/2,-0.01])
      {
        cube([m3_nut_width,m3_nut_height_cutout,motor_clamp_r-(motor_clamp_r-m3_nut_width)]);
      }
    }
    translate([0,0,7])
    {
      schnecke(1, gangzahl, laenge-7-7, bohrung_schnecke, eingriffswinkel, steigungswinkel, zusammen_gebaut);
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
  translate([0,0,stand_wall_w])
  {
    translate([
      motor_axle_offset[0],
      motor_length+motor_gearing_length+0.5,
      motor_axle_offset[1]]
    ){
      worm_drive();
    }

  }

  translate(bottle_holder_axle_offset_xyz)
  {
    rotate([0,90,0])
    {
      rotate([0,0,45])
      {
        container_holder();
      }
    }
  }

  stand();

} else if ("stand" == partname)
{
  stand();
} else if ("worm_drive" == partname)
{
  rotate([90,0,0])
  {
    worm_drive();
  }
} else if ("container_holder" == partname)
{
  container_holder();
}
