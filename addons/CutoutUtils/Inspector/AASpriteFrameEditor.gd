extends EditorProperty


#replaces the field for frames with an OptionButton with each of the textures names

#everything's horizontal size flage should be set to this so it can stretch out
#with the inspectio
const EDITORSIZEFLAGS = Control.SIZE_EXPAND_FILL | Control.SIZE_SHRINK_CENTER


var useIcons

#the control of the OptionButton
var list := makeList()
func makeList() -> OptionButton:
	var list = OptionButton.new()
	#make sure it expands
	list.size_flags_horizontal = EDITORSIZEFLAGS
	return list


#clear the list and fill it up again, in case the order of things have 
#or whether icons are to be used have been changed etc
func refactorList():
	list.clear()
	if objectHasTextures():
		var o = get_edited_object()
		
		#preview the icons in the list if declared so in the AASprite
		useIcons = o.previewIcons
		#go through the AAsprites textures resource and add names to the list 
		#one-by-one
		for i in range(o.textures.getSize()):
			
			var textureName = o.textures.names[i]
			if useIcons:
				var actualTexture = o.textures.getTexture(i)
				list.add_icon_item(actualTexture, textureName)
			else:
				list.add_item(textureName)
		#if there were no items add a placeholder
		if o.textures.getSize() == 0:
			list.add_item("Nothing")
		list.get_item_count()
		if useIcons:
			list.expand_icon = true
		list.select(o.frameInd) 
	else:
		#if there were no items add a placeholder
		list.add_item("Nothing")
		list.select(0)

#helper function returns whether or not the AASprite exists and has an AtlasArray
func objectHasTextures():
	var o = get_edited_object()
	return (o != null and 
			o.textures != null and 
			o.textures.get_class() == "AtlasArray")

# Called when the node enters the scene tree for the first time.
func _ready():
	var container = VBoxContainer.new()
	container.size_flags_horizontal = EDITORSIZEFLAGS
	refactorList()
	
	container.add_child(list)
	add_child(container)
	add_focusable(container)
	
	#connect this control to the object
	var o = get_edited_object()
	if o != null:
		#listen to any time and exported var has changed in the AAsprite
		o.connect("editorChanged", self, "_onObjectEditorChanged")
	list.connect("item_selected", self, "_onNewSelect")
	
	pass # Replace with function body.

func update_property():
	pass
#	if objectHasTextures():
#		var o = get_edited_object()
#		list.set_visible(true)
#		list.select(get_edited_object().frameInd)
#	else:
#		list.set_visible(false)

func _onNewSelect(ind):
	emit_changed("frameInd", ind, "", true)
	
func _onObjectEditorChanged():
	refactorList()
