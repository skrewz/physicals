esp8266_wdh = [25,48,33];
module esp8266_v2()
{
  % union()
  {
    // PCB:
    color("#333")
    {
      difference()
      {
        union()
        {
          translate([1,1,0])
            minkowski()
            {
              cube([esp8266_wdh[0]-2*1,esp8266_wdh[1]-2*1,0.01]);
              cylinder(r=1,h=1.5);
            }
        }
        for (xoff=[2,esp8266_wdh[0]-2])
          for (yoff=[2,esp8266_wdh[1]-2])
            translate([xoff,yoff,-0.01])
              cylinder(r=1.5,h=3);
      }
    }

    // PCB furniture:
    color("silver")
    {
      // Micro-USB plug:
      translate([(esp8266_wdh[0]-8)/2,-1,1.5])
        cube([8,5,2.5]);
      // Buttons:
      for (xoff=[5,esp8266_wdh[0]-5-2])
        translate([xoff,0,1.5])
          cube([2,4,2]);

      // MCU:
      translate([6.5,esp8266_wdh[0]+0.5,1.5])
        cube([12,15,3]);
    }

    // Pins:
    color("silver")
    {
      for (xoff=[0,esp8266_wdh[0]-2])
      translate([xoff,5,0])
        mirror([0,0,1])
          cube([2,esp8266_wdh[2],8]);
    }

    // Pin clearance when using Dupont cables:
    color("#800")
    {
        for (xoff=[0,esp8266_wdh[0]-2])
        translate([xoff,5,-8])
        mirror([0,0,1])
          cube([2,33,10]);
    }
  }
}
