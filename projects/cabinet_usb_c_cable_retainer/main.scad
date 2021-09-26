// Use partname to control which object is being rendered:
//
// _partname_values retainer cutout
partname = "display";

// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 2;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 0.5;

pad_wd = [20,20];
hole_r = 4;

// size according to the thinnest part of your cable:
cable_escape_channel_width = 5.4; // 5mm + wiggle room

// The "lip" is the oversizing of the insert for the cutout part:
cutout_lip_wd = [1,1];

hole_distance_from_pad = 10;
wall_width = 4;




module retainer_no_cutout()
{
  difference()
  {
    hull()
    {
      cube([pad_wd[0],pad_wd[1],wall_width]);
      translate([pad_wd[0]/2,pad_wd[1]+hole_distance_from_pad,0])
      {
        translate([0,0,wall_width/2])
        {
          rotate_extrude()
          {
            translate([hole_r+wall_width,0,0])
              circle(r=wall_width/2);
          }
        }
        /*   cylinder(r=hole_r+wall_width,h=wall_width); */
      }
    }
    // core of hole
    translate([pad_wd[0]/2,pad_wd[1]+hole_distance_from_pad,0])
    {
      translate([0,0,wall_width/2])
      {
        rotate_extrude()
        {
          difference()
          {
          translate([0,-wall_width/2])
            square([hole_r+wall_width/2,wall_width]);
          translate([hole_r+wall_width/2,0,0])
            circle(r=wall_width/2);
          }
        }
      }
    }

  }
}

module cutout_shape()
{
  translate([pad_wd[0]/2-cable_escape_channel_width/2,0,0])
  {
    cube([
      cable_escape_channel_width,
      pad_wd[1]+hole_distance_from_pad,
      wall_width
    ]);
    translate([-cutout_lip_wd[0],0,wall_width-cutout_lip_wd[1]])
    cube([
      2*cutout_lip_wd[0]+cable_escape_channel_width,
      pad_wd[1]+hole_distance_from_pad,
      cutout_lip_wd[1]
    ]);
  }
}

module retainer()
{
  difference()
  {
    retainer_no_cutout();
    cutout_shape();
  }
}


module cutout()
{
  intersection()
  {
    retainer_no_cutout();
    cutout_shape();
  }
}


// Convention: when an object is rendered using partname, position/rotate it
// according to printing suggestion
if ("display" == partname)
{
  retainer();
  translate([0,-1,wall_width])
  cutout();
} else if ("retainer" == partname)
{
  retainer();
} else if ("cutout" == partname)
{
  mirror([0,0,1])
  cutout();
}
