extends XMLParser
#unfortunately Godot doesn't have a high level xml tree parser, like python does

#raw size of image document the source is from
var rawSize := Vector2(100, 100)
var source = [] # maybe later I'll add support for multiple sources
var textures
var parts

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func mainRead():
	var s = ""
	while (read() == OK):
		
		match get_node_type():
			NODE_ELEMENT:
				match get_node_name():
					"data":
						readHeader()
					"source":
						source =readSource()
					"textures":
						textures = createTextureDict()
					"parts":
						parts = createPartsDict()
			NODE_ELEMENT_END:
				s += get_node_name() + " end"
				s += "\n"
			
#	print("textures:")
#	print(textures)
#	print("parts")
#	print(parts)

#copys the attributes of the current element node to a dictionary
func atts2Dict(tryInt = false) -> Dictionary:
	var d = Dictionary()
	var name; var value
	for i in range(get_attribute_count()):
		name = get_attribute_name(i)
		value = get_attribute_value(i)
		if tryInt and value.is_valid_integer():
			value = int(value)
		d[name] = value

	return d

#read the <data> attributes at the top
func readHeader():
	rawSize.x = int(get_named_attribute_value("width"))
	rawSize.y = int(get_named_attribute_value("height"))

#reads the fileloc of a source element
func readSource():
	return get_named_attribute_value("path")
	
# found the "<textures>" node
func createTextureDict():
	assert(get_node_name() == "textures")
	var out = {}
	var currentName
	var currentD : Dictionary = {}
	#just return empty dict if there are no elements
	if is_empty():
		return out
	while (read() == OK):
		if get_node_type() == NODE_ELEMENT:
			match get_node_name().to_lower():
				"texture":
					currentName = get_named_attribute_value("name")
					#initialise a new dictionary and the entry "foreign"
					currentD["foreign"] = []
				"rect", "pivot", "size":
					currentD[get_node_name()] = atts2Dict(true)
				"foreign":
					currentD["foreign"].append(atts2Dict(true))
		elif get_node_type() == NODE_ELEMENT_END:
			match get_node_name():
				"texture":
					out[currentName] = currentD; currentD = {}
				"textures":
					return out
	return out

#found the <parts> node
func createPartsDict():
	assert(get_node_name() == "parts")
	var out = {}
	var currentName
	var currentList := []
	#just return empty dict if there are no elements
	if is_empty():
		return out
	while (read() == OK):
		if get_node_type() == NODE_ELEMENT:
			match get_node_name():
				"part":
					currentName = get_named_attribute_value("name")
				"texture":
					currentList.append(get_named_attribute_value("name"))
		elif get_node_type() == NODE_ELEMENT_END:
			match get_node_name():
				"part":
					out[currentName] = currentList
					currentList = []
				"textures":
					return out
				
	return out
