extends Control
class_name Leaderboard

@onready var scores_container = get_node("%ScoresContainer") as VBoxContainer
@onready var score_line = preload("res://ui/score_line.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	refresh()


func refresh():
	var leaderboard = await Server.get_leaderboard()
	display(leaderboard)


func display(leaderboard):
	for child in scores_container.get_children():
		scores_container.remove_child(child)
	for item in leaderboard:
		var line = score_line.instantiate()
		line.score = item
		scores_container.add_child(line)

func _on_refresh_timer_timeout():
	refresh()
