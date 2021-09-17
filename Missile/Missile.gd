extends Area2D

signal explode(x,y)
signal missile_destroyed

var MOVE_SPEED = 400
var destination = Vector2(0,0)
var destination_set = false
var is_friendly = false
var internalIndicator = null
var rng = RandomNumberGenerator.new()
var yValueToDivide = 600
var divideNumber = 0
var divided = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func setup_divide():
	rng.randomize()
	var divideNumber = rng.randf_range(0, 5)
	if divideNumber > 3 && position.y < 400:
		yValueToDivide = rng.randf_range(position.y + 75, 400)
	
func divide():
	destination = Vector2(rng.randf_range(0, 800), 526)
	get_parent().create_missile(position, false)
	if (divideNumber > 4):
		get_parent().create_missile(position, false)
	divided = true

func set_destination(dest):
	destination = dest
	look_at(destination)
	destination_set = true
	
func set_indicator(indicator):
	internalIndicator = indicator

func set_color(color):
	$Trail.default_color = color
	is_friendly = true
	
func set_speed_multiplier(value):
	MOVE_SPEED = MOVE_SPEED * value

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (destination_set):
		position = position.move_toward(destination, delta * MOVE_SPEED)
		if (abs(position.x - destination.x) < 1 and abs(position.y - destination.y) < 1):
			explode()
	if (position.y > 526):
		explode()
		
	if not is_friendly and not divided and position.y > yValueToDivide:
		divide()

func _on_MissileMob_area_entered(area):
	if is_friendly and "Explosion" in area.name:
		pass
	elif is_friendly == false and "Spacecraft" in area.name:
		pass
	else:
		explode()
	
func explode():
	emit_signal("explode", position.x, position.y)
	if internalIndicator != null:
		internalIndicator.queue_free()
	if not is_friendly:
		emit_signal("missile_destroyed")
	queue_free()
