extends EditorInspectorPlugin

const TDPropEditor = preload("TextureDictPropEditor.gd")
const AAPropEditor = preload("AAPropEditor.gd")
const AASpriteFrameEditor = preload("AASpriteFrameEditor.gd")

#only handle textureDictionaries
func can_handle(object):
	if (object != null and object.has_method("get_class")
			and [
				"AtlasArray",
				"AASprite"
			].has(object.get_class())):
		return true
	return false

func parse_property(object, type, path, hint, hint_text, usage):
	if object == null: return false
	match object.get_class():
		"AtlasArray":
			if path == "buttons":
				add_property_editor(path, AAPropEditor.new())
				return true
		"AASprite":
			if path == "frame":
				add_property_editor(path, AASpriteFrameEditor.new())
				return true
	return false

#func parse_begin(object):
#	add_custom_control(AAPropEditor.new())

func parse_end():
	pass
