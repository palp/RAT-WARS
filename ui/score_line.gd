extends Control

var score = {}
@onready var positionLabel = get_node("%PositionLabel") as Label
@onready var nameLabel = get_node("%NameLabel") as Label
@onready var scoreLabel = get_node("%ScoreLabel") as Label
@onready var backgroundRect = get_node("%BackgroundRect") as ColorRect

# Called when the node enters the scene tree for the first time.
func _ready():
	if score.has("position") and score.has("name") and score.has("score"):
		positionLabel.text = str(score["position"])	
		nameLabel.text = str(score["name"])	
		scoreLabel.text = str(score["score"])
	if score.has("submitted") and score["submitted"]:
		backgroundRect.color = Color.DARK_RED
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
