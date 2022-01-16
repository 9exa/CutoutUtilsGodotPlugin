extends Resource
tool
#just stores an array of atlasTextures
const XMLReader = preload("res://addons/CutoutUtils/Importer/TextureDictionaryXMLParser.gd")


export (Array, Texture) var atlases = [] setget setAtlases

func setAtlases(values):
	if values != atlases:
		atlases = values
		#sets the default texture if appended through editor
		if (len(values) > 0 and 
				(values[-1] == null or not values[-1] is Texture)):
			values[-1] = StreamTexture.new()
		
		#resize names and pivots appropriately
		setNames(names)
		setPivots(pivots)

#give a name to each texture, may not be unique


export (PoolStringArray) var names = PoolStringArray() setget setNames

func setNames(values):
	#if new array is shorter than the number of textures
	#fill with the index as a string
	if values.size() < len(atlases):
		for i in range(values.size(), len(atlases)):
			values.append(str(i))
	else:
		values.resize(len(atlases))
	
	#tell potential listeners (the editor) that something's changed
	if values != names:
		names = values
		emit_changed()

export (PoolVector2Array) var pivots = PoolVector2Array() setget setPivots

func setPivots(values):
	#if new array is shorter than the number of textures
	#fill with pivots at the top left
	if values.size() < len(atlases):
		for i in range(values.size(), len(atlases)):
			values.append(atlases[i].get_size() * 0.5)
	else:
		values.resize(len(atlases))
	#tell potential listeners (the editor) that something's changed
	if values != pivots:
		pivots = values
		emit_changed()

#IMPORTANT. Using the Godot Editors native interface, you can swap items in each
#of the arrays around but currently items from the other arrays do not swap to 
#match that transaction.
#ie if you swap two textures in the 'atlases' area, then you're just swapping 
#their corresponding 'names' and 'pivots'


func get_class(): return "AtlasArray"

func getSize():
	return len(atlases)
#get the texture at that index
func getTexture(ind):
	if ind >= 0 and ind < len(atlases):
		return atlases[ind]

#loaders. Note that because we use the native godot editor, values won't change
#until you deselect and reselect the arrays

#loads in and sets to be data from an XMLfile
func fromXML(filePath):
	var reader = XMLReader.new()
	var E = reader.open(filePath)
	if E == OK:
		reader.mainRead()
		
		#abort if the source could not be loaded
		var sourceTexture = load(reader.source)
		if sourceTexture == null: return E
		
		var nameList = PoolStringArray()
		var newArray = []
		var pivotArray = PoolVector2Array()
		var newTexture
		#go line-by-line
		var rect; var piv
		for name in reader.textures.keys():
			newTexture = AtlasTexture.new()
			newTexture.atlas = sourceTexture
			newTexture.region = Rect2(
				reader.textures[name]["rect"].x,
				reader.textures[name]["rect"].y,
				reader.textures[name]["rect"].w,
				reader.textures[name]["rect"].h
			)
			pivotArray.append(Vector2(
				reader.textures[name]["pivot"].x,
				reader.textures[name]["pivot"].y
			))
			newArray.append(newTexture)
			nameList.append(name)
			
		
		atlases = newArray
		setNames(nameList)
		setPivots(pivotArray)
		emit_changed()
	return E

func _get_property_list():
	var properties = [
		
		#just here so we can replace it in the inspector
		{
			name = "buttons",
			type = TYPE_NIL,
			usage =  PROPERTY_USAGE_EDITOR 
		}
	]
	return properties
