
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
