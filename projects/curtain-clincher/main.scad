// Use partname to control which object is being rendered:
//
// _partname_values end_mount mid_clamp
partname = "display";


include <libs/compass.scad>
// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = $preview ? 12 : 4;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = $preview ? 2 : 0.5;

target_layer_height = 0.2;

wall_w = 3;
baseplate_thickness = 5;

plate_width = 24;
mount_width = plate_width;
// Negative extends off towards lesser x:
mount_cylinder_extension_width = -15;
mount_cut_in_wd = [10,0];
cylinder_height_over_mount = baseplate_thickness;

cylinder_cutout_r = (16.3+1.0)/2;
outrigger_upwards = 70;
outrigger_downwards = 20;

magnet_cutout_rh = [(8.1+0.2)/2,0.9+0.5];
mid_clamp_outrigger_wdh = [60,20,5];
mid_clamp_radius = 2;

module end_mount()
{
  clasp_dim = 2*(cylinder_cutout_r+wall_w);
  difference()
  {
    // The positive parts of the end_mount
    union ()
    {
      translate([0,-outrigger_downwards,0])
      {
        cube([plate_width,outrigger_downwards+clasp_dim+outrigger_upwards,baseplate_thickness]);
      }
      translate([(plate_width-mount_width)/2,0,0])
      {
        // Free-floating cylinder extension
        translate([
          0 > mount_cylinder_extension_width ? mount_cylinder_extension_width : 0,
          clasp_dim/2,
          cylinder_cutout_r+cylinder_height_over_mount,
        ]) {
          rotate([0,90,0])
          {
            cylinder(r=cylinder_cutout_r+wall_w,h=mount_width+abs(mount_cylinder_extension_width));
          }
        }
        hull()
        {
          translate([0,clasp_dim/2,cylinder_cutout_r+cylinder_height_over_mount])
          {
            rotate([0,90,0])
            {
              cylinder(r=cylinder_cutout_r+wall_w,h=mount_width);
            }
          }
          translate([(mount_width-plate_width)/2,0,0])
          {
            cube([plate_width, clasp_dim, 0.01]);
          }
        }
      }
    }
    // The hole through for the actual cylinder
    translate([-abs(mount_cylinder_extension_width)-0.01,clasp_dim/2,cylinder_cutout_r+cylinder_height_over_mount])
    {
      rotate([0,90,0])
      {
        cylinder(r=cylinder_cutout_r,h=2*abs(mount_cylinder_extension_width)+mount_width+0.02);
      }
    }

    // the mount_cut_in
    translate([-0.01,-outrigger_downwards-0.01,-0.01])
    {
      cube([
        mount_cut_in_wd[0],
        outrigger_downwards+clasp_dim+outrigger_upwards+0.02,
        mount_cut_in_wd[1]]
      );
    }
    
  }
}

module mid_clamp()
{
  difference()
  {
    union()
    {
      hull()
      {
        for (coord = [
          [-mid_clamp_outrigger_wdh[0]/2,mid_clamp_outrigger_wdh[1]/2,0],
          [-mid_clamp_outrigger_wdh[0]/2,-mid_clamp_outrigger_wdh[1]/2,0],
          [mid_clamp_outrigger_wdh[0]/2,-mid_clamp_outrigger_wdh[1]/2,0],
          [mid_clamp_outrigger_wdh[0]/2,mid_clamp_outrigger_wdh[1]/2,0],
          [0,mid_clamp_outrigger_wdh[1]/4,mid_clamp_outrigger_wdh[2]],
          [0,-mid_clamp_outrigger_wdh[1]/4,mid_clamp_outrigger_wdh[2]],
        ]) {
          translate(coord)
          {
            sphere(r=mid_clamp_radius, $fn=20);
          }
        }
      }
    }
    translate([0,0,-0.01])
    {
      // A magnet is attached to the frame but is hidden inside this space:
      cylinder(r=1.2*magnet_cutout_rh[0],h=magnet_cutout_rh[1]-2*target_layer_height,$fn=30);
      // This magnet is attached to the
      cylinder(r=magnet_cutout_rh[0],h=2*magnet_cutout_rh[1],$fn=30);

      // Avoiding wobbly overhangs in holes:
      for(i=[1,2])
      {
        rotate([0,0,30*i])
        {
          translate([0,0,magnet_cutout_rh[1]-i*target_layer_height])
          {
            cylinder(r=1.2*magnet_cutout_rh[0],h=target_layer_height,$fn=6);
          }
        }
      }
    }

    translate([-mid_clamp_outrigger_wdh[0],-mid_clamp_outrigger_wdh[1],-2*mid_clamp_radius])
    {
      cube([3*mid_clamp_outrigger_wdh[0],3*mid_clamp_outrigger_wdh[1],2*mid_clamp_radius]);
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
  end_mount();

  translate([100,0,0])
  {
    mid_clamp();
  }
} else if ("end_mount" == partname)
{
  end_mount();
} else if ("mid_clamp" == partname)
{
  mid_clamp();
}
