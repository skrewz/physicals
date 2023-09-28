
include <metric_bolts_and_nuts.scad>

n20_motor_gearing_length=9;
n20_motor_length=17;
n20_motor_axle_diameter=3;
n20_motor_axle_protrusion=9;
n20_motor_diameter=12;
n20_motor_axle_flattened_diameter=2.5;
n20_motor_gearing_width=12;
n20_motor_gearing_height=10;

module n20_axle ()
{
  intersection(){
    cylinder(r=n20_motor_axle_diameter/2,h=n20_motor_axle_protrusion,$fn=40);

    translate ([-n20_motor_axle_diameter/2,-n20_motor_axle_diameter/2,(/*ccf*/-0.01)*n20_motor_axle_protrusion])
      cube(size=[n20_motor_axle_diameter,n20_motor_axle_flattened_diameter,n20_motor_axle_protrusion*1.02]);
  }
}

module n20_motor ()
{
  // The motor itself:
  union () {
    color("grey")
      intersection(){
        cylinder(r=n20_motor_diameter/2,h=n20_motor_length);
        translate ([-n20_motor_gearing_width/2,-n20_motor_gearing_height/2,0])
          cube(size=[
            n20_motor_gearing_width,
            n20_motor_gearing_height,
            n20_motor_length
          ]);
      }
    // The gearing mechanism:
    color("yellow")
      translate([0,0,(/*ccf*/0.99)*n20_motor_length])
      translate ([-n20_motor_gearing_width/2,-n20_motor_gearing_height/2,0])
      cube(size=[
        n20_motor_gearing_width,
        n20_motor_gearing_height,
        n20_motor_gearing_length
      ]);
    // The axle:
    color("silver")
      translate([0,0,(/*ccf*/0.98)*(n20_motor_length+n20_motor_gearing_length)])
      n20_axle();
  }
}

module n20_axle_mount ()
{
  $fa = 1;
  $fs = 1;
  motor_clamp_r = 4+m3_nut_height_cutout;
  difference()
  {
    cylinder(r=motor_clamp_r,h=7);

    // motor axle:
    translate([0,0,-0.01])
    {
      // elephant foot clearing
      cylinder(r1=1.5*n20_motor_axle_diameter/2, r2=n20_motor_axle_diameter/2, h=0.5);
      cylinder(r=n20_motor_axle_diameter/2,h=2+n20_motor_axle_protrusion);
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
}
