# CutoutUtilsGodotPlugin
A Godot Plugin with tools to help with 2D cutout animations, and potentially 2D animations in general

The Main item of this package is the Atlas array, which holds an Array of (Atlas) Textures and assignes a name to them.
They can be imported using an XML file

Such XML files expect to be in the following form
```
<data>
  <!--The atlass of all textures in the Atlas Array-->
  <source path="res://pathtosourcetexture"/>
  <!--the entries in the atlas array-->
  <textures>
    <texture name="nametoAssign to this texture">
      <!--Rect2 region for this texture-->
      <rect x y w h/>
      <!-- intended (0,0) for this texture-->
      <pivot x y/>
    <texture/>
    <!--etc-->
  <textures/>

</data>
```
When you create an AtlasArray Resource you'll see a *Load XML* button.
