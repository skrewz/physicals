// Use partname to control which object is being rendered:
//
// _partname_values dial clasp
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 2;

labels=["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

wall_w=1;
lid_w=2;
dial_disc_height=3;
dial_lettering_height=2;
container_diameter=70;
container_lid_height=15;
peg_diameter=10;
dial_diameter=container_diameter+2*wall_w;
font_height=dial_diameter/10;

month_font="DejaVu Sans Mono:style=Bold";

module clasp()
{
  r = peg_diameter/2-0.5;
  translate([0,0,container_lid_height])
  {
    // cone-shaped to make disc not rotate in place:
    cylinder(r1=peg_diameter/2,r2=r,h=dial_disc_height+dial_lettering_height,$fn=30);
    // Place an arrow on top:
    translate([0,0,dial_disc_height+dial_lettering_height])
    {
      linear_extrude(height=dial_lettering_height)
      {
        polygon([
          [0,-r],
          [r/2,-r+r/2],
          [r/6,-r+r/2],
          [r/6,r],
          [-r/6,r],
          [-r/6,-r+r/2],
          [-r/2,-r+r/2],
        ]);
      }
    }
  }
  difference()
  {
    cylinder(r=container_diameter/2+1.5*wall_w,h=container_lid_height);
    // Add a bit of cone-shape to make it fit snuggly:
    cylinder(r1=wall_w/2+container_diameter/2,r2=container_diameter/2,h=container_lid_height-lid_w);
  }
}

module dial()
{
  difference()
  {
    union()
    {
      cylinder(r=dial_diameter/2,h=dial_disc_height);

      translate([0,0,dial_disc_height])
      {
        for (i = [0 : 1 : len(labels)]){
          rotate([0,0,i*360/len(labels)]) {
            translate([
                -(dial_diameter/2-font_height/4),
                -font_height/2,
                0])
            {
              linear_extrude(height=dial_lettering_height)
                text(labels[i],size=font_height,font=month_font, halign="left",$fn=10);
            }
          }
        }
      }
    }
    // On a perfect printer, 0.25 radius difference oughtn't be necessary, but
    // this should make it sit a bit lower on actual hardware:
    cylinder(r=peg_diameter/2+0.25,h=10,$fn=40);
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
  translate([0,0,60])
    dial();
  clasp();
} else if ("dial" == partname)
{
  dial();
} else if ("clasp" == partname)
{
  clasp();
}
