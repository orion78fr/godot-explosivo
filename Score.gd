extends Label

var score = 0

func _ready():
	reset_score();

func reset_score():
	add_to_score(-score)

func add_to_score(points):
	score += points
	update_score_text()

func update_score_text():
	text = "Score : " + str(score)
