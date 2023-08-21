// Use partname to control which object is being rendered:
//
// _partname_values sign1 sign2
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;


cylinder_fit_r = (35.77-1)/2;
sign_height = 15;
wall_w = 1.5;
span_angle_of_text = 180;



module sign1()
{
  sign("Sign 1");
}

module sign2()
{
  sign("Sign 2");
}

module sign(stext)
{
  chars = len( stext );
  difference()
  {
    union()
    {
      cylinder(r=cylinder_fit_r+wall_w,h=sign_height-wall_w);
      translate([0,0,sign_height-wall_w])
      {
        cylinder(r1=cylinder_fit_r+wall_w,r2=cylinder_fit_r,h=wall_w);
      }
      for(i=[0:1:chars])
      {
        rotate([0,0,i*span_angle_of_text/chars])
        {
          translate( [cylinder_fit_r,0,sign_height/2/2])
          {
            rotate([90,0,90])
            {
              minkowski()
              {
                sphere(r=0.8, $fn=$preview ? 5 : 20);
                linear_extrude(1.0*wall_w)
                {
                  text(stext[i],
                    size=sign_height/2,
                    valign="baseline",
                    halign="center",
                    font="Liberation Sans:style=Bold");
                }
              }
            }
          }
        }
      }
    }
    translate([0,0,-0.01])
    {
      cylinder(r=cylinder_fit_r,h=sign_height+0.02);
    }
    translate([-cylinder_fit_r/4/2,-cylinder_fit_r-2*wall_w,-0.01])
    {
      cube([cylinder_fit_r/4,cylinder_fit_r+2*wall_w,sign_height+0.02]);
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
  sign1();
  translate([4*cylinder_fit_r,0,0])
  {
    sign2();
  }
} else if ("sign1" == partname)
{
  sign1();
} else if ("sign2" == partname)
{
  sign2();
}
