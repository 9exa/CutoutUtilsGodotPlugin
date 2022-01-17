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


export (PoolStringArray) var names := PoolStringArray() setget setNames

#maps each name to it's corresponding index in the array
var nameIndexes := {}

func setNames(values):
	#if new array is shorter than the number of textures
	#fill with the index as a string
	if values.size() < len(atlases):
		for i in range(values.size(), len(atlases)):
			values.append(str(i))
	else:
		values.resize(len(atlases))
	
	
	if values != names:
		#going entry by entry, resolve duplicates by numbering them at the end
		#tell potential listeners (the editor) that something's changed
		var base; var n
		for i in range(values.size()):
			if i >= names.size():
				names.append("")
			if values[i] != names[i]:
				if values[i] in names:
					base = leftOfTrailingNumber(values[i])
					n = trailingNumber(values[i])
					while (base + str(n)) in names:
						n += 1
					values[i] = base + str(n)
				names.set(i, values[i])
		#change other things
		indexTheNames()
		emit_changed()

#filles up nameIndexes with the mapping of each name in names to their index
func indexTheNames():
	nameIndexes.clear()
	for i in range(names.size()):
		nameIndexes[names[i]] = i

#get the number (as an int) at the end of a string
#empty string is treated as 1
static func trailingNumber(s : String) -> int:
	if s.length() == 0 or not s[-1].is_valid_integer():
		return 1
	var i := 1
	while i <= s.length():
		if not s.right(s.length()-i).is_valid_float():
			return int(s.right(s.length()- i + 1))
		i += 1
	return int(s)
#gets the parts of a string left of its trailing number, if any
static func leftOfTrailingNumber(s: String) -> String:
	if s.length() == 0 or not s[-1].is_valid_integer():
		return s
	var i := 1
	while i <= s.length():
		if not s.right(s.length()-i).is_valid_float():
			return (s.left(s.length()- i +1))
		i += 1
	#whole thing is a number
	return ""


export (PoolVector2Array) var pivots := PoolVector2Array() setget setPivots

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

export (PoolVector2Array) var sizes := PoolVector2Array()

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
#get the texture with that name, if it exists
func getNamedTexture(name):
	return
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
