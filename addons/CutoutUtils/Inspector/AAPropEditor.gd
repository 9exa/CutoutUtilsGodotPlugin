extends EditorProperty
tool
#just adds a button that allows us to read an xml as
#an atlass array from the inspector

const EDITORSIZEFLAG = Control.SIZE_EXPAND_FILL | Control.SIZE_SHRINK_CENTER

#const FileOpener = preload("AAFilePopup.tscn")
class FileOpener extends EditorFileDialog:
	func _init(type):
		match type:
			#is for opening the xml template information
			"template":
				add_filter("*.xml; From Xtensible Markup")
			#is for selecting the source texture
			"image":
				add_filter("*.png, *jpeg; Images")
		mode = MODE_OPEN_FILE
		dialog_text = "You'll have to select and reselect the property arrays"
		set_anchor_and_margin(MARGIN_LEFT, 0.5, -300)
		set_anchor_and_margin(MARGIN_TOP, 0.5, -150)
		set_anchor_and_margin(MARGIN_RIGHT, 0.5, 300)
		set_anchor_and_margin(MARGIN_BOTTOM, 0.5, 150)
#		rect_min_size = Vector2(800,600)
#		set_anchors_and_margins_preset(Control.PRESET_CENTER)


#the popups that selects XML and image files for to open
var templateFileOpener := FileOpener.new("template")
var imageFileOpener := FileOpener.new("image")
#store the path to the template,
var templateFilePath := ""


var fromXMLButton = makeXMLButton()
func makeXMLButton():
	var but = Button.new()
	but.set_text("Load XML")
	but.size_flags_horizontal = EDITORSIZEFLAG
	return but
	




# Called when the node enters the scene tree for the first time.
func _ready():
	var container = VBoxContainer.new()
	container.size_flags_horizontal = EDITORSIZEFLAG
	
	#container.add_child(fromXMLButton)
	add_child(fromXMLButton)
	fromXMLButton.connect("pressed", self, "_onXMLPressed")
	set_bottom_editor(fromXMLButton)
	
	#add and connect the file popup
	add_child(templateFileOpener)
	add_child(imageFileOpener)
	templateFileOpener.connect("file_selected", self, "_onFileSelected", [1])
	imageFileOpener.connect("file_selected", self, "_onFileSelected", [2])
	
	pass # Replace with function body.

#bring up the file popup
func _onXMLPressed():
	templateFileOpener.popup()

#load the file selected from filepopup
func _onFileSelected(path, stage):
	match stage:
		1:
			#store path to template file
			templateFilePath = path
			#get user to pick image file
			imageFileOpener.popup()
		2:
			get_edited_object().fromXML(templateFilePath, path)
