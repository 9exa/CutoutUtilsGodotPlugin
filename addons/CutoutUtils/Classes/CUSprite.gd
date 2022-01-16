extends Node2D

#A sprite that takes in a TextureDictionary and can swap between them
export (Resource) var TextureDictionary


#the current texture in the textureDict the sprite takes
var frame = 0 setget setFrame


func setFrame(v):
	frame = v

#called when the texture to be displayed might change
func changeSprite():
	pass

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


