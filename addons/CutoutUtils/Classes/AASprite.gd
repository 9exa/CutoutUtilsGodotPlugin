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
			setFrameInd(frameInd)
		#otherwise either do nothing or render a normal texture
		else:
			setNotAA()
			
		#tell inspector that things have hanged
		emit_signal("editorChanged")

#called when we set textures to a non AtlasArray value
func setNotAA():
	atlasEquipped = false
	var ciRid = get_canvas_item()
	#important that we set it to -1, as this tells the AAsprite to re-render
	#when it is next equipped with a Atlas array
	frameInd = -1
	VisualServer.canvas_item_clear(ciRid)
	#if textures does exist but is a built in texture
	if textures != null and textures is Texture:
		#render it at it's center
		var rect = Rect2(-textures.get_size()/2, textures.get_size())
		VisualServer.canvas_item_add_texture_rect(ciRid,
				rect, textures.get_rid())

#encode wether "textures" holds an atlasArray
#faster than checking a string everytime
var atlasEquipped = false

#name of which texture in textures the sprite will display
export (String) var frame = "" setget setFrame, getFrame
#index of texture in textures the sprite will display
var frameInd := -1 setget setFrameInd

func setFrame(val):
	if textures != null and atlasEquipped and val != "":
		setFrameInd(textures.nameIndexes[val])
		

#frame is just the name of the texture at index framInd
func getFrame():
	if textures != null and atlasEquipped:
		return textures.names[frameInd]
	else:
		return "Not AtlasArray"

#forceRedraw causes the function to update the texture even if the set value is
#the same as the previous
func setFrameInd(val):
	if textures != null and atlasEquipped:
		#render the selected altasArray texture as appropriate
		val = clamp(val, 0, textures.getSize())
		if frameInd != val:
			frameInd = val
			displayTexture(frameInd)
			
			emit_signal("editorChanged")

#actually tells canvas item to draw the texture at ind
#move to seperate function so we can shove it into _notifications
func displayTexture(frameInd):
	var ciRid = get_canvas_item()
	VisualServer.canvas_item_clear(ciRid)
	var text : Texture = textures.getTexture(frameInd)
	var rect = Rect2(-textures.pivots[frameInd], text.get_size())
	#print(text)
	if text is AtlasTexture:
		#print("redrawing", rect, text.get_rid(), text.region)
		VisualServer.canvas_item_add_texture_rect_region(ciRid,
				rect,
				text.get_rid(), text.region)
	else:
		VisualServer.canvas_item_add_texture_rect(ciRid,
			rect,
			text.get_rid())

#whether to show icons in the drop in the editor dropdownmenu
#might want to disable if the textures themselves are too big
export var previewIcons := false setget setPreviewIcons
func setPreviewIcons(value):
	if previewIcons != value:
		previewIcons = value
		emit_signal("editorChanged")


func _ready():
	pass

func _notification(what):
	match what:
		#display the texture when it enters the scene
		NOTIFICATION_DRAW:
			if textures != null and atlasEquipped:
				displayTexture(frameInd)
			print("NOT_DRAW")

func _to_string():
	return "AtlasArraySprite"


