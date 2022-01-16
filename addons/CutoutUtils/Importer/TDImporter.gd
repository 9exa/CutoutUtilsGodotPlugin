extends EditorImportPlugin

#parser scripts
const TextureDictionary = preload("res://addons/CutoutUtils/Classes/TextureDictionary.gd")


enum Presets { DEFAULT }

func get_importer_name():
	"CutoutUtiles.TextureDictionary"

func get_resource_type():
	#we have to use generic resources as the editordoesn't recognize
	#custom created resources
	return "Resource"	

func get_visible_name():
	return "Texture Dictionary"

func get_recognized_extensions():
	return ["xml"]

func get_save_extension():
	return "res"

func get_preset_count():
	return Presets.size()

func get_preset_name(preset):
	match preset:
		Presets.DEFAULT:
			return "ThereIsOnlyOnePreset"
		_:
			return "How'd you get here?"
func get_import_options(preset):
	return []

func import(source_file, save_path, options, platform_variants, gen_files):
	var tDict
	match source_file.get_extension():
		"xml":
			tDict = TextureDictionary.new()
			var E = tDict.fromXML(source_file)
			if E != OK:
				return E
	ResourceSaver.save("%s.%s" % [save_path, get_save_extension()], tDict)
