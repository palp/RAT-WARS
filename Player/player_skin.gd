extends Node
class_name PlayerSkin

var texture:Texture2D
var unlocked:bool

func _init(_name:String, _texture:Texture2D, _unlocked:bool = false):
	name = _name
	texture = _texture
	unlocked = _unlocked

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
