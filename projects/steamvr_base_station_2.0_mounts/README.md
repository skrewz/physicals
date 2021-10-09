# Several mounts for SteamVR base stations 2.0

* `partname=wall_mounted_clasp` is a quick-detach outrigger that holds one base station. It comes off at an angle (`wall_mount_offset_angle`) and a length (`wall_mount_offset_length`) that takes it past a rolling curtain.

* `partname=wall_plate` is the thing that `wall_mounted_clasp` hooks into. It's designed to mount two medium-sized 3M Command hooks (albeit without the hook, only using the part that adheres to the wall). You may want to sand it down a bit to get the 3M hooks to snap on neatly before proceeding with...:

* `partname=mount_for_3m_adhesive_cover`, which is one of the two cover plates for covering up openings of `wall_plate`. While they can be printed "on their back," a neater surface finish is achieved by printing them with a deliberate bridge inside them, possibly using brim to hold the thin bottom walls onto the print bed. Be conscious of how the infill angle looks like on the top surface, too.


* `partname=shelf_mounted_clasp` is something entirely different. This mounts onto some beams of a piece of furniture. Adjust the beam size with `shelf_beam_cutout_wd` and angles with `shelf_screwmount_rotation`.
