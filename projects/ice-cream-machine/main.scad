// Use partname to control which object is being rendered:
//
// _partname_values stand worm_drive container_holder
partname = "display";

include <libs/compass.scad>
include <libs/gears.scad>
include <libs/n20.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;


gear_teeth = 60;
gear_width = 5;

// Salsa dip container circumference/height: 271mm/77mm
container_rh = [271/(3.1415*2), 77+2];


n20_motor_axle_offset = [7, container_rh[1]/2];
stand_wdh = [3*container_rh[0], 1.7*gear_teeth, 0];

n20_motor_mount_r_scale_factor = 1.1;

wall_w = 2;
stand_wall_w = 3;


n20_motor_axle_protrusion=9;
n20_motor_axle_diameter=3;

offset_for_gear = 1*gear_teeth/2;

bottle_holder_axle_offset_xyz = [
  n20_motor_axle_offset[0]-gear_width/2,
  n20_motor_length+n20_motor_gearing_length+1.4*offset_for_gear,
  offset_for_gear+n20_motor_axle_offset[1]+6
];


free_moving_axle_r = 4;
free_moving_axle_bearing_oversize = 0.7;
axle_bearing_wd = [2*n20_motor_axle_offset[0],2*stand_wall_w];

bottle_holder_length = stand_wdh[0]-n20_motor_axle_offset[0]+gear_width/2;
bottle_holder_axle_r = free_moving_axle_r+wall_w;

bottle_axis_bearing_offsets = [
    gear_width+5,
    bottle_holder_length-axle_bearing_wd[1],
];

module stand()
{
  module axle_bearing (radius_height, closed=false)
  {
    translate([-axle_bearing_wd[0]/2,0,0])
    {
      difference()
      {
        cube([axle_bearing_wd[0],axle_bearing_wd[1],radius_height+2*free_moving_axle_r]);
        translate([n20_motor_axle_offset[0],0,radius_height])
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
    n20_motor_mount();
  }

  translate([n20_motor_axle_offset[0],stand_wdh[1]-axle_bearing_wd[1],stand_wall_w])
  {
    axle_bearing(n20_motor_axle_offset[1], true);
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

module n20_motor_mount()
{
  difference()
  {
    cube([
      2*n20_motor_axle_offset[0],
      n20_motor_length,
      n20_motor_gearing_width/2+n20_motor_axle_offset[1]]
    );
    translate([n20_motor_axle_offset[0],0,n20_motor_axle_offset[1]])
    {
      rotate([-90,0,0])
      {
        rotate([0,0,90])
        {
          intersection()
          {
            cylinder(r=n20_motor_mount_r_scale_factor*n20_motor_diameter/2,h=n20_motor_length);
            translate([
              -n20_motor_mount_r_scale_factor*n20_motor_gearing_width/2,
              -n20_motor_mount_r_scale_factor*n20_motor_gearing_height/2,
              0]){
              cube([
                n20_motor_mount_r_scale_factor*n20_motor_gearing_width,
                n20_motor_mount_r_scale_factor*n20_motor_gearing_height,
                n20_motor_mount_r_scale_factor*n20_motor_length]);
            }
          }
          translate([
            -n20_motor_mount_r_scale_factor*n20_motor_gearing_width,
            -n20_motor_mount_r_scale_factor*n20_motor_gearing_height/2,
            0]){
            cube([
              n20_motor_mount_r_scale_factor*n20_motor_gearing_width,
              n20_motor_mount_r_scale_factor*n20_motor_gearing_height,
              n20_motor_mount_r_scale_factor*n20_motor_length]);
          }
          %
          n20_motor();
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
  laenge=stand_wdh[1]-n20_motor_length-n20_motor_gearing_length-2;
  bohrung_schnecke=3; //worm_bore;
  bohrung_rad=bore;
  nabendicke=final_hub_thickness;
  nabendurchmesser=6; //final_hub_diameter;
  eingriffswinkel=20; //pressure_angle;
  steigungswinkel=8; //lead_angle;
  zusammen_gebaut=true; //true;


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
    n20_axle_mount();
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
      n20_motor_axle_offset[0],
      n20_motor_length+n20_motor_gearing_length+0.5,
      n20_motor_axle_offset[1]]
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
