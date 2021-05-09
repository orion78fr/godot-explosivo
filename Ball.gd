extends Sprite

const X_SIZE = 10
const Y_SIZE = 15
const BALL_SIZE = 40

var color = null;
var x = -1;
var y = -1;

var accel = Vector2()
var expected_position = Vector2()

const GRAVITY = 10

func _ready():
	self.position = Vector2(x * BALL_SIZE, (Y_SIZE - 1 - y) * BALL_SIZE)
	self.expected_position = position

func set_coords(x, y):
	self.x = x;
	self.y = y;
	self.expected_position = Vector2(x * BALL_SIZE, (Y_SIZE - 1 - y) * BALL_SIZE)

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
