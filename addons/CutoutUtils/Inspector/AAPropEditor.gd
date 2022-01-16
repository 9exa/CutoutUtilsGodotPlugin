extends EditorProperty
tool
#just adds a button that allows us to read an xml as
#an atlass array from the inspector

const EDITORSIZEFLAG = Control.SIZE_EXPAND_FILL | Control.SIZE_SHRINK_CENTER

#const FileOpener = preload("AAFilePopup.tscn")
class FileOpener extends EditorFileDialog:
	func _init():
		add_filter("*.xml; From Xtensible Markup")
		mode = MODE_OPEN_FILE
		dialog_text = "You'll have to select and reselect the property arrays"
		set_anchor_and_margin(MARGIN_LEFT, 0.5, -300)
		set_anchor_and_margin(MARGIN_TOP, 0.5, -150)
		set_anchor_and_margin(MARGIN_RIGHT, 0.5, 300)
		set_anchor_and_margin(MARGIN_BOTTOM, 0.5, 150)
#		rect_min_size = Vector2(800,600)
#		set_anchors_and_margins_preset(Control.PRESET_CENTER)
		
		

#the popup that selects XML and other files for to open
var fileOpener := FileOpener.new()

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
	add_child(fileOpener)
	fileOpener.connect("file_selected", self, "_onFileSelected")
	
	pass # Replace with function body.

#bring up the file popup
func _onXMLPressed():
	fileOpener.popup()

#load the file selected from filepopup
func _onFileSelected(path):
	get_edited_object().fromXML(path)
