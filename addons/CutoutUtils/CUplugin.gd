extends EditorPlugin
tool

#There may be some other unused files here from old implementations

#handles all the inspector stuff, don't forget to free
var inspector
var importer

func _enter_tree():
	var gui = get_editor_interface().get_base_control()
	var AAicon = gui.get_icon("TileMap", "EditorIcons")
	var Spricon = gui.get_icon("Skeleton2D", "EditorIcons")
	
	add_custom_type("AtlasArray",
					"Resource",
					preload("Classes/AtlasArray.gd"),
					AAicon)
	add_custom_type("AASprite",
					"Node2D",
					preload("Classes/AASprite.gd"),
					Spricon
	)
	
	inspector = preload("Inspector/Inspector.gd").new()
	add_inspector_plugin(inspector)
	
	importer = preload("Importer/AAImporter.gd").new()
	add_import_plugin(importer)


func _exit_tree():
	remove_custom_type("AtlasArray")
	remove_custom_type("AASprite")
	
	remove_inspector_plugin(inspector)
	inspector = null
	
	remove_import_plugin(importer)
	importer = null
