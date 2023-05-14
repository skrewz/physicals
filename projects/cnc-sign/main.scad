// Use partname to control which object is being rendered:
//
// _partname_values sign
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 50;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 4;

sign_wdh = [270,100,23];
sign_radius = 5;

font_thickness = 3;
font_height = 20;
// Hint, choose font with:
// fc-list -f "%{file}\n" | grep -i '\.ttf$' | xargs -n 1 sh -c 'echo $0; convert -size 600x200 -gravity center -background white -fill black -font "$0" label:"$(basename $0)" "$(basename $0).png"'
font_string = "Quicksand:style=Bold";

margin = 5;
line_spacing = 10;

text_lines = [
  "Here we have",
  "a winter haiku verse",
  "for CNC mills"
];

module sign()
{
  translate([sign_radius, sign_radius,0])
  {
    minkowski()
    {
      cube([sign_wdh[0], sign_wdh[1], 0.01] - [2*sign_radius,2*sign_radius,0]);
      cylinder(r=sign_radius, h=sign_wdh[2]-font_thickness,$fn=20);
    }
  }
  translate([margin, sign_wdh[1]-margin-font_height,sign_wdh[2]-font_thickness])
  {
    for (y_index = [0:len(text_lines)])
    {
      translate([0,-y_index*(font_height+line_spacing),0])
      {
        linear_extrude(height = font_thickness)
        {
          text(text_lines[y_index], font=font_string, size=font_height);
        }
      }
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
  sign();
} else if ("sign" == partname)
{
  sign();
}
