extends Node

signal content_unlocked(content)

var unlocked_content = []

func unlock(code):
	var unlocks = await Server.unlock_content(code)
	for content in unlocks:		
		print_debug("Unlocking " + content)
		unlocked_content.append(content)
		emit_signal("content_unlocked", content)
