// Use partname to control which object is being rendered:
//
// _partname_values connector_rack
partname = "display";

// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 12;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 2;

inter_rack_h_range = [95,105];
lower_rack_h = 54;
metal_piece_r = 2.5;

wall_w = 3;
piece_wd = [20,5];

module clasp ()
{
  translate([-3*wall_w,piece_wd[1],0])
  {
    difference()
    {
      cube([5*wall_w,3*wall_w,piece_wd[0]]);

      translate([3*wall_w,wall_w,-0.01])
        cylinder(r=1.2*metal_piece_r,h=piece_wd[0]+0.02,$fn=20);
      for(off = [0,3*wall_w])
      {
        hull()
        {
          for(off = [0,3*wall_w])
            translate([off,wall_w,-0.01])
              cylinder(r=1.1*metal_piece_r,h=piece_wd[0]+0.02,$fn=20);
        }
      }
    }
  }
}

module holder ()
{
  translate([-wall_w-1.2*metal_piece_r,piece_wd[1],0])
  {
    difference()
    {
      cube([
        max(inter_rack_h_range)-min(inter_rack_h_range)+3*wall_w + 1.2*metal_piece_r,
        3*wall_w,
        piece_wd[0]]);

      hull()
      {
        for(off = [wall_w+1.2*metal_piece_r,max(inter_rack_h_range)])
          translate([off,wall_w,-0.01])
            cylinder(r=1.2*metal_piece_r,h=piece_wd[0]+0.02,$fn=20);
      }
    }
  }
}


module connector_rack ()
{

  translate([-3*wall_w,0,0])
    cube([
      max(inter_rack_h_range)+54+2*wall_w+(max(inter_rack_h_range)-min(inter_rack_h_range)),
      piece_wd[1],
      piece_wd[0]
    ]);
  for (off = [0,54])
    translate([off,0,0])
     clasp();

  // reinforcement circle around stress point:
  translate([lower_rack_h+wall_w+1.2*metal_piece_r,wall_w,0])
  {
    difference()
    {
      cylinder(r=2.5*wall_w,h=piece_wd[0]);
      translate([-3*wall_w,0,-0.01])
        cube([6*wall_w,6*wall_w,piece_wd[0]+0.02]);
    }
  }

  translate([54+wall_w+1.2*metal_piece_r,piece_wd[1],0])
    cube([min(inter_rack_h_range)-2*(wall_w+1.2*metal_piece_r),3*wall_w,wall_w]);

  translate([54+min(inter_rack_h_range),0,0])
    holder();
}





// Conventions:
// * When an object is rendered using partname, position/rotate it according to
//   printing suggestion, here. (The module itself will be positioned/rotated
//   like it will be, in the put-together "display" situation.)
// * The special value "display" for partname is the product picture for all
//   parts put together.
if ("display" == partname)
{
  connector_rack();
} else if ("connector_rack" == partname)
{
  rotate([0,0,0])
  {
    connector_rack();
  }
}
