extends Node

const X_SIZE = 10
const Y_SIZE = 15

const X_OFFSET = 100
const Y_OFFSET = 100

const BALL_SIZE = 40

var num_color = 4
var COLORS = [
		Color.from_hsv(0, .5, 1), # red
		Color.from_hsv(.33, .5, 1), # green
		Color.from_hsv(.53, .5, 1), # light blue
		Color.from_hsv(.825, .5, 1), # pink
		Color.from_hsv(.07, .5, 1), # orange
		Color.from_hsv(.664, .5, 1), # dark blue
		Color.from_hsv(.164, .5, 1) # yellow
	]

var board = {}

onready var Ball = preload("res://Ball.tscn")

onready var score = $"../Score"
onready var game_over_screen = $"../Game Over Screen"

# Move things
func set_sizes():
	var window_size = Vector2(X_OFFSET * 2 + (X_SIZE-1) * BALL_SIZE, Y_OFFSET * 2 + (Y_SIZE-1) * BALL_SIZE)
	print(window_size)
	OS.set_window_size(window_size)
	score.rect_size.x = window_size.x
	score.rect_position.y = OS.get_window_safe_area().position.y
	
	$"More colors".rect_position.y = window_size.y - 50
	$"Less colors".rect_position.y = window_size.y - 50
	$"Color number label".rect_position.y = window_size.y - 50

func _ready():
	set_sizes()
	
	# Set the random generator seed
	randomize()
	
	reset_game()

func reset_game():
	game_over_screen.visible = false
	# Reset score
	score.reset_score()
	
	if num_color < 3:
		num_color = 3
	if num_color > COLORS.size():
		num_color = COLORS.size()
	
	$"Color number label".text = "Colors : " + str(num_color)
	
	generate_new_board()

func generate_new_board():
	# Remove balls
	for key in board:
		remove_child(board[key])
	board = {}
	
	# Generate new batch of balls
	for x in range(X_SIZE):
		for y in range(Y_SIZE):
			var ball = Ball.instance()
			var color_id = int(rand_range(0, num_color))
			ball.set_color(COLORS[color_id], color_id)
			ball.set_coords(x, y)
			add_child(ball)
			
			board[Vector2(x,y)] = ball

func explode(x, y):
	var p = Vector2(x,y)
	var color = board[p].color
	
	var balls_to_explode = {p: true}
	explore(color, balls_to_explode, p)
	
	if balls_to_explode.size() > 1:
		for b in balls_to_explode:
			remove_child(board[b])
			board.erase(b)
		
		compact()
		
		score.add_to_score(2 * balls_to_explode.size() - 1)
		
		if board_is_locked():
			if board.empty():
				generate_new_board()
			else:
				game_over_screen.visible = true

func get_adjacent(p):
	return [p+Vector2(-1, 0), p+Vector2(0, -1), p+Vector2(1, 0), p+Vector2(0, 1)]

func explore(color, exploding, p):
	for new_p in get_adjacent(p):
		if board.has(new_p):
			var ball = board[new_p]
			if ball.color == color && !exploding.has(new_p):
				exploding[new_p] = true
				explore(color, exploding, new_p)

func gravity():
	for x in range(X_SIZE):
		for y in range(Y_SIZE):
			if !board.has(Vector2(x,y)):
				# Column has a hole
				for y2 in range(y+1, Y_SIZE):
					var new_point = Vector2(x, y2)
					# Find if a ball is levitating over, and move it to this hole
					if board.has(new_point):
						var ball = board[new_point]
						board.erase(new_point)
						board[Vector2(x,y)] = ball
						ball.set_coords(x,y)
						break

func compact():
	gravity()
	for x in range(X_SIZE):
		# Empty column
		if !board.has(Vector2(x, 0)):
			for x2 in range(x+1, X_SIZE):
				# Find the next non-empty column
				if board.has(Vector2(x2, 0)):
					# Move the column
					for y in range(Y_SIZE):
						if board.has(Vector2(x2, y)):
							var ball = board[Vector2(x2, y)]
							board.erase(Vector2(x2, y))
							board[Vector2(x,y)] = ball
							ball.set_coords(x,y)
						else:
							break
					break

func board_is_locked():
	for x in range(X_SIZE):
		for y in range(Y_SIZE):
			var p = Vector2(x, y)
			if board.has(p):
				var color = board[p].color
				for new_p in get_adjacent(p):
					if board.has(new_p) && board[new_p].color == color:
						return false
	return true

func _on_Less_colors_pressed():
	num_color -= 1
	reset_game()

func _on_More_colors_pressed():
	num_color += 1
	reset_game()

func _on_Reset_pressed():
	reset_game()
