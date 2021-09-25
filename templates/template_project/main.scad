// Use partname to control which object is being rendered:
//
// _partname_values unit_circle
partname = "unit_circle";

// $fa is the minimum angle for a fragment. Minimum value is 0.01.
$fa = 12;
// $fs is the minimum size of a fragment. If high, causes
// fewer-than-$fa-would-indicate surfaces. Minimum is 0.01.
$fs = 2;

module unit_circle()
{
  sphere(r=1);
}


// Convention: when an object is rendered using partname, position/rotate it
// according to printing suggestion
if ("unit_circle" == partname)
{
  rotate([0,0,0])
  {
    unit_circle();
  }
}
