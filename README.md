# CutoutUtilsGodotPlugin
A Godot Plugin with tools to help with 2D cutout animations, and potentially 2D animations in general

The Main item of this package is the Atlas array, which holds an Array of (Atlas) Textures and assignes a name to them.
They can be imported using an XML file

Such XML files expect to be in the following form
```
<data width = "rawimageWidth" height = "rawImageHeight">
  <!--
      the entries in the atlas array.
   -->
  <textures>
    <texture name="nametoAssign to this texture">
      <!--Rect2 region for this texture in source-->
      <region x y w h/>
      <!--
      intended (0,0) for this texture
      as of current this is relative to the rect in the uncompressed raw source
      texture
      -->
      <pivot x y/>
      <!--
	size of the texture do be displayed in an AAsprite
	Leave blank to default to size of texture
      -->
    <texture/>
    <!--etc-->
  <textures/>

</data>
```
When you create an AtlasArray Resource you'll see a *Load XML* button.


###TODO
Support for multiple source files in AtlasArray
Support for size declaration in AtlasArray
