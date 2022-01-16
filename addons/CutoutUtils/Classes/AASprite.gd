extends Node2D
tool

#displays a selected item from a Atlass array
func get_class():
	return "AASprite"
	

#special signal tells editor inspector that the drop-down menu
#might need updating
signal editorChanged

#The atlas array that this sprite renders
export (Resource) var textures setget setTextures

func setTextures(val):
	var ciRid = get_canvas_item()
	if val != textures:
		#when stuff in the resource changes, AASprite will want to tell the editor
		if val != null:
			val.connect("changed", self, "emit_signal", ["editorChanged"])
		#disconnect from the old resource
		if (textures != null and 
				textures.is_connected("changed", self, "emit_signal")):
			textures.disconnect("changed", self, "emit_signal")
		
		textures = val
		
		#if we just equiped an AtlasArray we can render it as such
		if textures != null and textures.get_class() == "AtlasArray":
			atlasEquipped = true
			setFrame(frame)
		#otherwise either do nothing or render a normal texture
		else:
			atlasEquipped = false
			VisualServer.canvas_item_clear(ciRid)
			
			#render a normal texture
			if textures != null and textures is Texture:
				setFrame(frame)
			
		#tell inspector that things have hanged
		emit_signal("editorChanged")

#encode wether "textures" holds an atlasArray
#faster than checking a string everytime
var atlasEquipped = false



#which texture in textures the sprite will display
export var frame := 0 setget setFrame


func setFrame(val):
	var ciRid = get_canvas_item()
	
	if textures != null and atlasEquipped:
		#render the selected altasArray texture as appropriate
		val = clamp(val, 0, textures.getSize())
		if frame != val:
			
			VisualServer.canvas_item_clear(ciRid)
			frame = val
			var text : Texture = textures.getTexture(frame)
			var rect = Rect2(-textures.pivots[frame], text.get_size())
			
			if text is AtlasTexture:
				VisualServer.canvas_item_add_texture_rect_region(ciRid,
						rect,
						text.get_rid(), text.region)
			else:
				VisualServer.canvas_item_add_texture_rect(ciRid,
					rect,
					text.get_rid())
	else:
		#important that we set it to -1, as this tells the AAsprite to re-render
		#when it is next equipped with a Atlas array
		frame = -1
		VisualServer.canvas_item_clear(ciRid)
		#if textures does exist but is a built in texture
		if textures != null and textures is Texture:
			#render it at it's center
			var rect = Rect2(-textures.get_size()/2, textures.get_size())
			VisualServer.canvas_item_add_texture_rect(ciRid,
					rect, textures.get_rid())


#whether to show icons in the drop in the editor dropdownmenu
#might want to disable if the textures themselves are too big
export var previewIcons := false setget setPreviewIcons
func setPreviewIcons(value):
	if previewIcons != value:
		previewIcons = value
		emit_signal("editorChanged")



func _to_string():
	return "AtlasArraySprite"


