extends Sprite

var X_SIZE = -1
var Y_SIZE = -1

var X_OFFSET = -1
var Y_OFFSET = -1

var BALL_SIZE = -1

var color = null;
var x = -1;
var y = -1;

var accel = Vector2()
var expected_position = Vector2()

const GRAVITY = 10

func _ready():
	X_SIZE = get_parent().X_SIZE
	Y_SIZE = get_parent().Y_SIZE
	X_OFFSET = get_parent().X_OFFSET
	Y_OFFSET = get_parent().Y_OFFSET
	BALL_SIZE = get_parent().BALL_SIZE
	
	self.position = Vector2(X_OFFSET + x * BALL_SIZE, Y_OFFSET + (Y_SIZE - 1 - y) * BALL_SIZE)
	self.expected_position = position

func set_coords(x, y):
	self.x = x;
	self.y = y;
	self.expected_position = Vector2(X_OFFSET + x * BALL_SIZE, Y_OFFSET + (Y_SIZE - 1 - y) * BALL_SIZE)

func set_color(color, color_id):
	self.modulate = color
	self.color = color_id

func add_accel(vect):
	self.accel += vect

func _process(delta):
	if position == expected_position:
		return;
	
	accel += (expected_position - position).normalized() * GRAVITY * delta
	
	position += accel
	
	if has_went_too_far(accel.x, position.x, expected_position.x):
		position.x = expected_position.x
		accel.x = 0
	
	if has_went_too_far(accel.y, position.y, expected_position.y):
		position.y = expected_position.y
		accel.y = 0

func has_went_too_far(accel, pos, exp_pos):
	return (accel > 0 && pos >= exp_pos && pos - accel < exp_pos) \
			|| (accel < 0 && pos <= exp_pos && pos - accel > exp_pos)