# A case that fits a `.png` image

This is to enable secure storage of flat-packed objects. Designed for storing a
flat seasonal decoration securely between years.

![Generated display preview](render/display.png "Generated display preview")

I never made this work. The concept is sound, I think, but the devil is in the
details.

First off, I suspect you're better off scanning your flat-pack objects, as
opposed to photographing them. I did the latter, and I think some of my issues
were related to perspective etc. Of course, if you've produced the flatpack
object yourself, you should prefer to go straight to the source of truth.

If they have texture on one side, scan them on the blander side and rotate in
software. This makes the image manipulation more straightforward.

This case assumes that you've pre-processed the image similarly to
`cutout.png`:

* Added enough padding around the shape itself.
   * You have the basic image in black and white, in image editing programmes,
     you can use blurring and contrast/brightness before indexing back to two
     colours again.
* Converted to black-and-white.
* Cropped the image to the outer edge of the `cutout_bounding_box` you've
  configured. As a tip, you should do this last, after adding padding etc.

Depending on image resolution, this tends to make OpenSCAD fairly memory hungry.
