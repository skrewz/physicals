// Use partname to control which object is being render
//
// _partname_values slider slider_cradle_test top_sheet bottom_plate
partname = "display";


// TODO:
// - derive top_sheet_wdh[0] and [1] from labels and largest
//   x_coord_for_label/y_coord_for_label value
// - Place M3 cutouts for both bolts and nuts (bolt faces countersunk)
// - Make top_sheet_wdh[2] and bottom_plate_base_height possible to make fairly
//   high (for rigidity)
// - With fasteners; shrink default wall width of bottom_plate_margin
// - Derive extra_label_x_spacing from widest label value



include <libs/compass.scad>
include <libs/metric_bolts_and_nuts.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 1 : 0.5;

// Early definitions (that are used for user-configurable settings):
fastener_mount_thickness = 0.8;
m3_chosen_nut_cutout_h = min(3,m3_nut_height_cutout);
m3_chosen_cap_clear_h = min(1,m3_cap_clear_height);
m3_chosen_flat_cap_radius_cutout=(6.83+0.5)/2;

// The label to place at the base of the board
// Note: in reverse order
heading_labels = [
  "Cleaning 3/week",
];
heading_label_font = "DejaVu Sans Mono:style=Bold";
heading_label_height = 6;

// The sliders' labels, individually
slider_labels = [
  ["Mon","","Tue","","Wed","","Thu","","Fri","","Sat","","Sun",],
  [],
  ["W01","W02","W03","W04","W05","W06","W07","W08","W09","W10","W11","W12","W13","W14",],
  ["W15","W16","W17","W18","W19","W20","W21","W22","W23","W24","W25","W26","W27","W28",],
  ["W29","W30","W31","W32","W33","W34","W35","W36","W37","W38","W39","W40","W41","W42",],
  ["W43","W44","W45","W46","W47","W48","W49","W50","W51","W52","W53"],
];
// In case the labels overflow, expand the grid with this much to make
// wider labels fit:
extra_label_x_spacing = 3;

slider_labels_font = "DejaVu Sans Mono:style=Bold";
slider_labels_font_height = 3;


// Top sheet size:
top_sheet_wdh = [147,115,m3_chosen_cap_clear_h+1];

// The radius and length of the slider
slider_rl = [2.5, 10];
slider_knob_rh = [1.5, top_sheet_wdh[2]+2];


bottom_plate_base_height = m3_chosen_nut_cutout_h+fastener_mount_thickness;
bottom_plate_margin = 2;
bottom_plate_expansion_xy = [0.2, 0.2];
bottom_plate_rounding_r = bottom_plate_margin;

// How frequently room should be made for fasteners
fastener_int = 6;


// Internal parameters; unlikely to need modification:
slider_layer_height = 1;
slider_spring_width = 0.4;
slider_spring_gap = 1;
slider_spring_protrusion = 0.6;

// The minimum distance between cradles:
slider_cradle_separation = 0.8;

// Not sure if this is necessary, this should only be necessary for slider_cradle_test():
slider_cradle_wall_w = 2;

slider_cradle_gap_hv = [0.3, 0.4];

slider_cradle_travel = slider_rl[1]-2*slider_rl[0];

slider_labels_font_thickness = 0.4;


// Distances between repetitions in x and y intervals:
x_int = extra_label_x_spacing+2*slider_cradle_gap_hv[0]+slider_rl[1]+slider_cradle_travel;
y_int = -(2*slider_cradle_gap_hv[0]+2*slider_rl[0]+slider_spring_protrusion+slider_cradle_separation);

// Indent, to be applied against top_sheet()'s origin vs its repetition calls:
top_sheet_indentation_xy = [
  0,
  -slider_rl[0]-max(m3_chosen_flat_cap_radius_cutout,(slider_spring_protrusion+slider_cradle_separation)),
];

// TODO: should probably relate to max(m3_chosen_flat_cap_radius_cutout,...):
extra_fastener_x_spacing = 0.7*x_int;

// Generally, one will want fasteners every 30mm, give or take, to avoid looseness:
num_fasteners_y = floor(top_sheet_wdh[1]/50);



function x_coord_for_label(i) = i == 0 ? top_sheet_indentation_xy[0] + extra_label_x_spacing + extra_fastener_x_spacing : x_coord_for_label(i-1) + x_int + (i % fastener_int == 0 ? extra_fastener_x_spacing : 0);
function y_coord_for_label(i) = i == 0 ? top_sheet_indentation_xy[1] : y_coord_for_label(i-1) + y_int;

function x_coord_for_fastener(i) = i == 0 ? top_sheet_indentation_xy[0] +extra_label_x_spacing + extra_fastener_x_spacing/2 : extra_fastener_x_spacing/2 + x_coord_for_fastener(i-1) + fastener_int*x_int + extra_fastener_x_spacing/2;
function y_coord_for_fastener(i) = i == 0 ? top_sheet_indentation_xy[1] : y_coord_for_fastener(i-1) - (top_sheet_wdh[1]+2*top_sheet_indentation_xy[1])/(num_fasteners_y-1);


// Note that slider() is centered on the position of the slider's beginning
// edge in the "engaged" (pushed rightwards) position
module slider()
{
  // The main slider body
  difference()
  {
    hull()
    {
      translate([slider_rl[0],0,0])
      {
        cylinder(r=slider_rl[0], h=slider_layer_height);
      }
      translate([slider_rl[1]-slider_rl[0],slider_rl[0]-slider_knob_rh[0],0])
      {
        cylinder(r=slider_knob_rh[0], h=slider_layer_height);
      }
      translate([slider_rl[1]-slider_rl[0],-(slider_rl[0]-slider_knob_rh[0]),0])
      {
        cylinder(r=slider_knob_rh[0], h=slider_layer_height);
      }
    }
    translate([slider_rl[0],slider_rl[0]-slider_spring_width-slider_spring_gap,-0.01])
    {
      cube([slider_rl[1]-2*slider_rl[0],slider_rl[0],slider_layer_height+0.02]);
    }
    // Complicated shape that furthers the cutout along the circle of the hull() above:

    translate([slider_rl[0],0,-0.01])
    {
      intersection()
      {
        difference()
        {
          cylinder(r=slider_rl[0]-slider_spring_width, h=slider_layer_height+0.02);
          cylinder(r=slider_rl[0]-slider_spring_width-slider_spring_gap, h=slider_layer_height+0.02);
        }
        translate([-slider_rl[1],-slider_rl[0]+2*slider_knob_rh[0],0])
        {
          cube([slider_rl[1],slider_rl[0],slider_layer_height+0.02]);
        }
      }
    }
  }

  // The bow of the spring
  translate([slider_rl[0],slider_rl[0]-slider_spring_width,0])
  {
    difference()
    {
      union()
      {
        cube([slider_rl[1]-2*slider_rl[0],slider_spring_width,slider_layer_height]);
        translate([(slider_rl[1]-2*slider_rl[0])/2,-slider_rl[0]+slider_spring_width+slider_spring_protrusion,0])
        {
          cylinder(r=slider_rl[0], h=slider_layer_height);
        }
      }
      translate([(slider_rl[1]-2*slider_rl[0])/2,-slider_rl[0]+slider_spring_width+slider_spring_protrusion,-0.01])
      {
        cylinder(r=slider_rl[0]-slider_spring_width, h=slider_layer_height+0.02);
      }
      mirror([0,1,0])
      {
        translate([0,0,-0.01])
        {
          cube([slider_rl[1]-2*slider_rl[0],slider_rl[0],slider_layer_height+0.02]);
        }
      }
    }
  }

  // The slider knob
  translate([slider_rl[1]-slider_rl[0],-(slider_rl[0]-slider_knob_rh[0]),0])
  {
    cylinder(r=slider_knob_rh[0], h=slider_knob_rh[1]);
  }
}

module slider_cradle_pos()
{
  translate([0,-slider_rl[0]-slider_cradle_wall_w,0])
  {
    cube([
        slider_rl[1]+slider_cradle_travel+2*slider_cradle_gap_hv[0]+2*slider_cradle_wall_w,
        2*slider_rl[0]+2*slider_cradle_wall_w,
        2*slider_layer_height
    ]);
  }
}
module slider_cradle_neg()
{

  // The main slider body cutout hull:
  hull()
  {
    for (xoff = [
        slider_rl[0]+slider_cradle_gap_hv[0]+slider_cradle_wall_w,
        -slider_rl[0]+slider_cradle_gap_hv[0]+slider_cradle_wall_w+slider_rl[1]+slider_cradle_travel,
    ]) {
      translate([xoff,0,-0.01])
      {
        cylinder(r=slider_rl[0]+slider_cradle_gap_hv[0], h=slider_layer_height+slider_cradle_gap_hv[1]+0.01);
      }
    }
  }

  // The slider knob cutout hull:
  hull()
  {
    for (xoff = [
        0,
        slider_cradle_travel,
    ]) {
      translate([xoff,0,0])
      {
        // The slider knob
        translate([slider_rl[1]-slider_cradle_gap_hv[0],-(slider_rl[0]-slider_knob_rh[0]),-0.01])
        {
          cylinder(r=slider_knob_rh[0]+slider_cradle_gap_hv[0], h=slider_knob_rh[1]+top_sheet_wdh[2]);
        }
      }
    }
  }
  for (xoff = [0, slider_cradle_travel])
  {
    // The snap points for the slider_spring_protrusion pieces:
    translate([
        xoff+slider_cradle_wall_w+(slider_rl[1]-2*slider_rl[0])/2+(slider_rl[0]+slider_cradle_gap_hv[0]),
        slider_spring_protrusion,
        -0.01
    ]) {
      cylinder(r=slider_rl[0]+slider_cradle_gap_hv[0], h=slider_layer_height+slider_cradle_gap_hv[1]+0.01);
    }
  }

}

module slider_cradle_test ()
{
  difference()
  {
    slider_cradle_pos();
    slider_cradle_neg();
  }
}

// Helper module to repeat something for each label, x_int/y_int offset-wise
module place_for_labels ()
{
  for (xi = [0:len(slider_labels)-1])
  {
    if (0 < len(slider_labels[xi]))
    {
      for (yi = [0:len(slider_labels[xi])-1])
      {
        if (0 != len(slider_labels[xi][yi]))
        {
          translate([x_coord_for_label(xi),y_coord_for_label(yi),0])
          {
            children();
          }
        }
      }
    }
  }
}

// Helper module to repeat something for each fastener
module place_for_fasteners ()
{
  max_x_label_coord = len(slider_labels);
  max_y_label_coord = max([for (xi = [0:len(slider_labels)-1]) len(slider_labels[xi])]);

  for (xi = [0:max_x_label_coord-1])
  {
    for (yi = [0:max_y_label_coord-1])
    {
      translate([x_coord_for_fastener(xi),y_coord_for_fastener(yi),0])
      {
        children();
      }
    }
  }
}

module top_sheet()
{
  difference()
  {
    union()
    {
      cube(top_sheet_wdh);

      translate([top_sheet_wdh[0]/2,0.1*heading_label_height,top_sheet_wdh[2]])
      {
        color("white")
        {
          linear_extrude(height=slider_labels_font_thickness)
          {
            for (i = [0:len(heading_labels)-1])
            {
              translate([0,i*1.5*heading_label_height,0])
              {
                text(heading_labels[len(heading_labels)-1-i], font=heading_label_font, size=heading_label_height, valign="bottom", halign="center");
              }
            }
          }
        }
      }

      translate([0,top_sheet_wdh[1],top_sheet_wdh[2]])
      {
        for (xi = [0:len(slider_labels)-1])
        {
          if (0 < len(slider_labels[xi]))
          {
            for (yi = [0:len(slider_labels[xi])-1])
            {
              translate([x_coord_for_label(xi)+0.7*slider_rl[1],y_coord_for_label(yi),0])
              {
                color("white")
                {
                  linear_extrude(height=slider_labels_font_thickness)
                  {
                    text(slider_labels[xi][yi], font=slider_labels_font, size=slider_labels_font_height, valign="top", halign="right");
                  }
                }
              }
            }
          }
        }
      }
    }
    translate([0,top_sheet_wdh[1],-0.01])
    {
      place_for_fasteners()
      {
        cylinder(r=m3_radius_for_cutaway, h=bottom_plate_base_height+top_sheet_wdh[2]);
        translate([0,0,fastener_mount_thickness])
        {
          cylinder(r=m3_chosen_flat_cap_radius_cutout, h=m3_chosen_cap_clear_h+top_sheet_wdh[2]);
        }

      }
    }
    translate([0,top_sheet_wdh[1],-2*slider_layer_height])
    {
      place_for_labels()
      {
        slider_cradle_neg();
      }
    }
  }
}

module bottom_plate()
{
  // Logically derived values:
  difference()
  {
    difference()
    {
      minkowski()
      {
       cylinder(r=bottom_plate_rounding_r,h=0.001,$fn=20);
      translate([bottom_plate_rounding_r,bottom_plate_rounding_r,0])
      {
        cube([
            top_sheet_wdh[0]+2*bottom_plate_margin+bottom_plate_expansion_xy[0]-2*bottom_plate_rounding_r,
            top_sheet_wdh[1]+2*bottom_plate_margin+bottom_plate_expansion_xy[1]-2*bottom_plate_rounding_r,
            top_sheet_wdh[2]+bottom_plate_base_height
        ]);
      }
      }
    }
    translate([
        bottom_plate_margin,
        bottom_plate_margin,
        bottom_plate_base_height
    ]) {
      cube([
          top_sheet_wdh[0]+bottom_plate_expansion_xy[0],
          top_sheet_wdh[1]+bottom_plate_expansion_xy[1],
          top_sheet_wdh[2]+0.01
      ]);
      translate([
          bottom_plate_expansion_xy[0]/2,
          top_sheet_wdh[1]+bottom_plate_expansion_xy[1]/2,
          0
      ]) {
        translate([0,0,-bottom_plate_base_height-0.01])
        {
          place_for_fasteners()
          {
            cylinder(r=m3_nut_width_fn6_cutout_r, h=m3_chosen_nut_cutout_h, $fn=6);
            rotate([0,0,45])
            {
              cylinder(r=m3_radius_for_cutaway/cos(180/4), h=bottom_plate_base_height+top_sheet_wdh[2], $fn=4);
            }
          }
        }
        translate([0,0,-slider_layer_height-slider_cradle_gap_hv[1]+0.01])
        {
          place_for_labels()
          {
            slider_cradle_neg();
          }
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
  translate([
      bottom_plate_margin+bottom_plate_expansion_xy[0]/2,
      bottom_plate_margin+bottom_plate_expansion_xy[1]/2,
      bottom_plate_base_height
  ]) {
    top_sheet();
  }
  bottom_plate();

  translate([0,2*top_sheet_wdh[1],0])
  {
    slider();
  }
} else if ("slider_cradle_test" == partname)
{
  rotate([0,180,0])
  {
    slider_cradle_test();
  }
} else if ("top_sheet" == partname)
{
  top_sheet();
} else if ("bottom_plate" == partname)
{
  bottom_plate();
} else if ("slider" == partname)
{
  slider();
}
