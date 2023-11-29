extends Node

const UNLOCK_CODES = {
	"plugsuit": "PLUGSUIT" # TODO load final unlock codes from somewhere a little more secure
}

signal content_unlocked(content)

var unlocked_content = []

func unlock(code):
	for content in UNLOCK_CODES:
		if code == UNLOCK_CODES[content] and not unlocked_content.has(content):
			print_debug("Unlocking " + content)
			unlocked_content.append(content)
			emit_signal("content_unlocked", content)
