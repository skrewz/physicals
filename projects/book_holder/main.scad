// Use partname to control which object is being rendered:
//
// _partname_values holder
partname = "display";

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

module holder ()
{
  difference()
  {
    union()
    {
      planes();

      // Place handle
      rotate([-lean_angle,0,0])
      {
        rotate([0,0,opening_angle/2])
        {
          translate([0,-0.4*book_side_support_wh[0],0.85*book_side_support_wh[1]])
          rotate([0,90,0])
          rotate([0,handle_downward_angle,0])
          handle();
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
  translate([0,0,10])
  {
    holder();
  }
} else if ("holder" == partname)
{
  holder();
}
