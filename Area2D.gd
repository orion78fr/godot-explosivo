extends Area2D

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton \
    		and event.button_index == BUTTON_LEFT \
    		and event.is_pressed():
		var ball = get_parent()
		ball.get_parent().explode(ball.x, ball.y)