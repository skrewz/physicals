mount_for_3m_adhesive_wdh = [25,3,62];

3m_hook_channel_wd = [6.4, 1.40];
3m_hook_channel_minlength = 31;

3m_hook_insert_wd = [25.0,3.0];

// The "body" is the narrow part of the cutout. The torso extends sideways from
// that.
3m_hook_body_w = 13.80;
3m_hook_body_h_offsets = [2.8,30.8];
// The "torso" is the wider part in the middle of the cutout:
3m_hook_torso_w = 16.80;
3m_hook_torso_h_offsets = [10.8, 22.8];

// The 3m_claspspace_thickness is the thickness of material that the clasp
// needs to hook over, over the channel cutout on the other side:
3m_hook_claspspace_thickness = 0.6;
// The clearance is how much height the 3M clasp needs to slide in:
3m_hook_claspspace_clearance = 3.3;
3m_hook_claspspace_r = 2;
3m_hook_claspspace_h = 4.5;

module mount_for_3m_adhesive_neg ()
{
  // Insert body
  translate([(3m_hook_insert_wd[0]-3m_hook_body_w)/2,0,3m_hook_body_h_offsets[0]])
    cube([
      3m_hook_body_w,
      3m_hook_claspspace_clearance+3m_hook_channel_wd[1]+3m_hook_claspspace_thickness,
      3m_hook_body_h_offsets[1]-3m_hook_body_h_offsets[0]
    ]);

  // Insert torso
  translate([(3m_hook_insert_wd[0]-3m_hook_torso_w)/2,0,3m_hook_torso_h_offsets[0]])
    cube([
      3m_hook_torso_w,
      3m_hook_insert_wd[1],
      3m_hook_torso_h_offsets[1]-3m_hook_torso_h_offsets[0]
    ]);

  // Insert channel
  translate([(3m_hook_insert_wd[0]-3m_hook_channel_wd[0])/2,0,3m_hook_body_h_offsets[1]])
    cube([
      3m_hook_channel_wd[0],
      3m_hook_channel_wd[1],
      3m_hook_channel_minlength
    ]);

  // Cut out claspspace
  translate([
      (3m_hook_insert_wd[0]-3m_hook_body_w)/2,
      3m_hook_channel_wd[1]+3m_hook_claspspace_thickness,
      3m_hook_body_h_offsets[1]-0.01]
    ) {
      cube([
        3m_hook_body_w,
        3m_hook_claspspace_clearance,
        3m_hook_claspspace_h-3m_hook_claspspace_r,
      ]);
      // radiused part of claspspace:
      hull()
      {
        for (xoff=[3m_hook_claspspace_r,3m_hook_body_w-3m_hook_claspspace_r])
          translate([xoff,0,3m_hook_claspspace_h-3m_hook_claspspace_r])
            rotate([-90,0,0])
              cylinder(
                r=3m_hook_claspspace_r,
                h=3m_hook_claspspace_clearance,
                $fs=0.1);
      }
    }
}

