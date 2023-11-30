extends Control

@onready var items = get_node("%ItemList") as ItemList

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh()

func refresh():
	var leaderboard = await Server.get_leaderboard()	
	display(leaderboard)

func display(leaderboard):
	items.clear()
	for item in leaderboard:
		items.add_item(item.name + "     %d" % item.score)
	
func _on_refresh_timer_timeout():
	refresh()
