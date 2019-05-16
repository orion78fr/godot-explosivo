extends Button

func _pressed():
	get_node("/root/Root/Board").reset_game()