extends Node
class_name PlayerCharacter

var current_skin:String = "default"
var skins:Dictionary = {}

func _init(_name:String, default_skin:Texture2D, extra_skins:Dictionary = {}):
	name = _name	
	skins = {"default": PlayerSkin.new("default", default_skin, true)}	
	for key in extra_skins:
		if typeof(extra_skins[key]) == typeof(PlayerSkin):
			skins[key] = extra_skins[key]

func get_current_skin():
	return skins[current_skin]
	
func set_current_skin(skin:String):
	if skins.has(skin):
		current_skin = skin
