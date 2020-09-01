#  Readme

Known problems 

* Lea has suggested changing the Text Entry modal to one that is like Instagram, so I'm working on that now
* Card name: Top TextField in navigation bar used to work in previous beta. Now it only accepts one character.
* I've implemented Particles, but I don't know what chapter it is going in yet. Particles is a good example of drawing - could be gesture related. But might be removed. They aren't currently saved
* Carousel: Doesn't work well in iPhone landscape
* iPad portrait. Card view extends under bottom bar.
* Would be nice to have custom alignment somewhere - design?
* Share screenshot blocks UI - can't show share sheet until image is completed 
* The pink flower photo in the simulator default photos doesn't load

To do:

* Animation not yet implemented (chapter 15) - plan to have a hero animation with matchedGeometryEffect, but it doesn't work yet. Also, element long press delete menu will have a better animation too.

Changes I'll probably make:

* `ResizableView()` seems better as `.resizable`, so I will make `ElementContextMenu` a view builder and leave `ResizableViewModifier` in.  

Doubts that I have:

* Is Model / Card / Element set up right? The elements are updated in `Card`, and Cards are added and deleted in `Model` - the save out to disk is done in `Card`, but the load from disk of all cards is in `Model`.
