module compass (length=20)
{
  $fn=20;
  module arm(armlen)
  {
    cylinder(r=0.2,h=armlen-2);
    translate([0,0,armlen-2])
    cylinder(r1=0.6,r2=0.01,h=2);
  }
  % union ()
  {
    rotate([0,90,0])
      color("red")
        arm(length);
    rotate([-90,0,0])
      color("green")
        arm(length);
    rotate([0,0,0])
      color("blue")
        arm(length);
  }
}

