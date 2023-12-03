extends Node

signal content_unlocked(content)

#Characters
var player_characters = {
	"john": PlayerCharacter.new(
		"John", preload("res://assets/player/character/john/john_placeholder.png"),
		{
			"plugsuit": PlayerSkin.new(
				"Plugsuit", preload("res://assets/player/character/john/john_plugsuit.png"))
		}),
	"jake": PlayerCharacter.new(
		"Jake", preload("res://assets/player/character/jake/jake.png")),
	"beej": PlayerCharacter.new(
		"Beej", preload("res://assets/player/character/beej/beej.png"))
}

var selected_character:String

var unlocked_content = []

func unlock(code):
	var unlocks = await Server.unlock_content(code)
	for content in unlocks:		
		print_debug("Unlocking " + content)
		unlocked_content.append(content)
		emit_signal("content_unlocked", content)

func select_character(character_id:String):
	if player_characters.has(character_id):
		selected_character = character_id
		
func get_player_character():
	return player_characters[selected_character]
