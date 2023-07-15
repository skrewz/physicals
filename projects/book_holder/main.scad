// Use partname to control which object is being rendered:
//
// _partname_values holder page_clip
partname = "display";

include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 5;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 0.5;

// $fa = 10;
// $fs = 1;
wall_w = 5;
handle_length = 70;
handle_downward_angle = 30;

book_side_support_wh = [85,130];
book_base_support_d = 35;
book_base_rim_cutout_d = 10;
book_base_rim_cutout_r = 20;

opening_angle = 120;
lean_angle = 30;

page_clip_material_thickness = 7;

page_clip_width = 10;
page_clip_depth = book_base_support_d/2;
page_clip_height = book_base_support_d;
page_clip_clearance = 1;
page_clip_grab_extension = 5;
page_clip_bar_width = 0.75*book_base_support_d;
page_clip_elastic_extension = 10;


clip_holder_pivot_axle_r = 1.7;
clip_holder_width = page_clip_width + 2*page_clip_clearance + 2*wall_w;

clip_elastic_offset = 0.5*page_clip_depth;
// depends on which kind of elastic you'd intend to use:
clip_elastic_spread = 80;


module big_book ()
{
  // 26cm high, 20 cm wide, 4.5cm thick:
  rotate([-lean_angle,0,0])
  {
    for (m = [[0,0,0],[1,0,0]])
    {
      mirror(m)
      {
        rotate([0,0,-opening_angle/2/2])
        {
        %
          mirror([0,1,0])
          translate([0,wall_w/2,wall_w])
          cube([200,22.5,260]);
        }
      }
    }
  }
}

module support_column (h)
{
  cylinder(r=10,h=h);
}


module handle ()
{
  
  hull()
  {
    for (off=[[0,10],[10,3]])
      translate(off)
      {
        translate([0,0,-10])
          cylinder(r=10,h=handle_length+10);
        translate([0,0,handle_length])
          sphere(r=10);
      }
  }
}

module support_plane()
{
  translate([-book_side_support_wh[0],-book_base_support_d-(wall_w/2),0])
  {
    union()
    {
      // Bottom part of plane
      translate([wall_w/2,wall_w/2,0])
        cube([book_side_support_wh[0]-wall_w/2,book_base_support_d+wall_w/2-wall_w/2,wall_w]);


      // Neatness edge cylinder shapes
      translate([wall_w/2,wall_w/2,wall_w/2])
      {
        rotate([0,90,0])
          cylinder(r=wall_w/2,h=book_side_support_wh[0]-wall_w/2);

        rotate([-90,0,0])
          cylinder(r=wall_w/2,h=book_base_support_d+wall_w/2-wall_w/2);

        sphere(r=wall_w/2);
      }

      translate([wall_w/2,book_base_support_d+wall_w/2,wall_w/2])
      {
        rotate([0,90,0])
          cylinder(r=wall_w/2,h=book_side_support_wh[0]-wall_w/2);
        // Ball joining bottom and top
        sphere(r=wall_w/2);
      }

      // Upright part of plane:
      translate([wall_w/2,book_base_support_d,wall_w/2])
        cube([book_side_support_wh[0]-wall_w/2,wall_w,book_side_support_wh[1]-wall_w/2-wall_w/2]);

      translate([wall_w/2,book_base_support_d+wall_w/2,wall_w/2])
        cylinder(r=wall_w/2,h=book_side_support_wh[1]-wall_w/2-wall_w/2);

      translate([wall_w/2,book_base_support_d+wall_w/2,book_side_support_wh[1]-wall_w/2])
      {
        rotate([0,90,0])
          cylinder(r=wall_w/2,h=book_side_support_wh[0]-wall_w/2);
        sphere(r=wall_w/2);
      }



      // Vertical column
      translate([book_side_support_wh[0],book_base_support_d+(wall_w/2),0])
      {
        cylinder(r=wall_w/2,h=book_side_support_wh[1]-wall_w/2);
        translate([0,0,book_side_support_wh[1]-wall_w/2])
          sphere(r=wall_w/2);

      }
    }
  }
}

module planes_cutout()
{
  rotate([-lean_angle,0,0])
  {
    for (m = [[0,0,0],[1,0,0]])
    {
      mirror(m)
      {
        rotate([0,0,opening_angle/2/2])
        {
          // wall_w/4 isn't perfect, but good enough
          mirror([1,1,0])
            translate([wall_w/2,wall_w/4,wall_w])
              cube([book_base_support_d,2*book_side_support_wh[0],2*book_side_support_wh[1]]);
          // cut ridge/center for rim of hardback to rest in:
          mirror([1,1,0])
            translate([wall_w/2,wall_w/4,wall_w-1])
              cube([book_base_rim_cutout_d,2*book_side_support_wh[0],wall_w]);

        }
      }
    }
  }
}

module planes()
{
  // Place planes
  rotate([-lean_angle,0,0])
  {
    rotate([0,0,opening_angle/2/2])
    {
      support_plane();
      rotate([0,0,opening_angle])
        mirror([0,1,0])
        support_plane();
    }
  }
}

//big_book();

module round_cylinder(r, h)
{
  translate([0,0,r])
  {
    sphere(r=r);
    cylinder(r=r, h=h-2*r);
  }
  translate([0,0,h-r])
  {
    sphere(r=r);
  }
}

module page_clip()
{
  page_clip_triangle_scale = 2;
  page_clip_pivot_axle_r = 1.5;
  page_clip_pivot_axle_clearance = 0.5;

  rotate([0,90,0])
  {

    difference()
    {
      union()
      {
        hull()
        {
          cylinder(r=page_clip_material_thickness/2, h=page_clip_width);
          translate([0,-page_clip_depth,0])
          {
            round_cylinder(r=page_clip_material_thickness/2, h=page_clip_width);
          }
        }
        translate([0,-page_clip_depth,0])
        {
          hull()
          {
            round_cylinder(r=page_clip_material_thickness/2, h=page_clip_width);
            translate([-(page_clip_height-page_clip_material_thickness/2),0,page_clip_width/2])
            {
              rotate([0,90,0])
              {
                cylinder(r=page_clip_material_thickness/2,h=0.01);
              }
            }
          }
          // Pivot axle:
          translate([-(page_clip_height-page_clip_material_thickness/2),0,page_clip_width/2])
          {
            rotate([0,-90,0])
            {
              cylinder(r=page_clip_pivot_axle_r,h=page_clip_material_thickness+2*page_clip_pivot_axle_clearance);
            }
          }
          translate([-(page_clip_height+page_clip_material_thickness/2+2*page_clip_pivot_axle_clearance),0,page_clip_width/2])
          {
            hull()
            {
              rotate([0,90,0])
              {
                cylinder(r=page_clip_material_thickness/2,h=0.01);
              }
              translate([-page_clip_grab_extension,0,0])
              {
                sphere(r=page_clip_material_thickness/2);
              }
            }
          }
        }
        difference()
        {
          hull()
          {
            translate([-(page_clip_height+page_clip_pivot_axle_clearance),-page_clip_depth,page_clip_width/2])
            {
              rotate([0,-90,0])
              {
                for(coord = [
                  [-page_clip_triangle_scale*page_clip_bar_width,0],
                  [page_clip_triangle_scale*page_clip_bar_width,0],
                ]) {
                  translate(coord)
                  {
                    sphere(r=page_clip_material_thickness/2);
                  }
                }
              }
            }
          }
          translate([-page_clip_height,-page_clip_depth,page_clip_width/2])
          {
            rotate([0,90,0])
            {
              translate([0,0,-page_clip_material_thickness/2-page_clip_pivot_axle_clearance])
              {
                cylinder(r=page_clip_pivot_axle_r+0.5, h=page_clip_material_thickness);
              }
            }
          }
        }
      }
      translate([0,0,-0.01])
      {
        cylinder(r=clip_holder_pivot_axle_r, h=page_clip_width+0.02);
      }
    }
  }
}

module holder ()
{
  difference()
  {
    union()
    {
      planes();

      // Place handles
      rotate([-lean_angle,0,0])
      {
        for(m = [0,1])
        {
          mirror([m,0,0])
          {
            rotate([0,0,opening_angle/2])
            {
              translate([0,-0.4*book_side_support_wh[0],0.85*book_side_support_wh[1]])
              rotate([0,90,0])
              rotate([0,handle_downward_angle,0])
              handle();
            }
          }
        }
      }


      // Place page clip
      rotate([-lean_angle,0,0])
      {
        translate([0,-book_base_support_d,0])
        {
          // Clip base
          rotate([0,90,0])
          {
            translate([0,0,-clip_holder_width/2])
            {
              difference()
              {
                hull()
                {
                  cylinder(r=page_clip_material_thickness/2, h=clip_holder_width);
                  translate([page_clip_material_thickness,0,0])
                  {
                    cylinder(r=page_clip_material_thickness/2, h=clip_holder_width);
                  }
                  translate([page_clip_material_thickness,page_clip_elastic_extension,0])
                  {
                    cylinder(r=page_clip_material_thickness/2, h=clip_holder_width);
                  }
                }
                translate([page_clip_material_thickness,0,-0.01])
                {
                  cylinder(r=clip_holder_pivot_axle_r, h=clip_holder_width+0.02);
                }
                translate([0,0,page_clip_width/2])
                {
                  hull()
                  {
                    cylinder(r=page_clip_material_thickness/2+0.01, h=page_clip_width+2*page_clip_clearance);
                    translate([page_clip_material_thickness,0,0])
                    {
                      cylinder(r=page_clip_material_thickness/2+0.01, h=page_clip_width+2*page_clip_clearance);
                    }
                    translate([page_clip_material_thickness,page_clip_elastic_extension,0])
                    {
                      cylinder(r=page_clip_material_thickness/2+0.01, h=page_clip_width+2*page_clip_clearance);
                    }
                  }
                }
              }
            }
          }
        }
      }

      // Place elastic mounts
      rotate([-lean_angle,0,0])
      {
        translate([0,-book_base_support_d-clip_elastic_offset,0])
        {
          for (coord = [
            [-clip_elastic_spread/2,0,0],
            [clip_elastic_spread/2,0,0],
          ]){
            translate(coord)
            {
              translate([0,0,-wall_w])
              {
                cylinder(r1=wall_w,r2=wall_w/2,h=wall_w);
              }
            }
          }
        }
      }

      /*
      for (off = [-0.72*book_side_support_wh[0],0.72*book_side_support_wh[0]])
        translate([off,0,0])
          support_column(0.7*book_side_support_wh[1]);
      */

      // support structure
      translate([0,sin(lean_angle)*book_base_support_d,0])
      {
        translate([0,-4,1])
          scale([2.0,1.5,0.3])
          {
            sphere(r=30);
          }

        translate([0,0,0])
            rotate([-0.5*lean_angle,0,0])
          scale([0.2,0.2,3])
          {
              sphere(r=30);
          }
      }
    }
    planes_cutout();

    mirror([0,0,1])
      translate([-500,-500,0])
      cube([1000,1000,1000]);
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
  holder();
  rotate([-lean_angle,0,0])
  {
    translate([0,-book_base_support_d,0])
    {
      translate([-page_clip_width/2,0,-page_clip_material_thickness])
      {
        rotate([-10,0,0])
        {
          page_clip();
        }
      }
    }
  }
} else if ("holder" == partname)
{
  holder();
} else if ("page_clip" == partname)
{
  rotate([90,0,0])
  {
    page_clip();
  }
}
