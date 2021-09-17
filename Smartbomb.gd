extends Area2D

signal explode(x,y)
signal smartbomb_destroyed

export (PackedScene) var explosion

var health = 5
var MOVE_SPEED = 60
var bump_distance = 15
var bump_destination = Vector2(0,0)
var destination = Vector2(0,0)
var destination_set = false
var bump_destination_set = false

func _ready():
	add_to_group("enemy")

func set_destination(dest):
	destination = dest
	look_at(destination)
	destination_set = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if bump_destination_set:
		position = position.move_toward(bump_destination, delta * MOVE_SPEED)
		if (abs(position.x - bump_destination.x) < 1 and abs(position.y - bump_destination.y) < 1):
			bump_destination_set = false
	elif (destination_set):
		position = position.move_toward(destination, delta * MOVE_SPEED)
		if (abs(position.x - destination.x) < 1 and abs(position.y - destination.y) < 1):
			explode()
	if (position.y > 526):
		explode()

func _on_Smartbomb_area_entered(area):
	if area is Explosion:
		if area.is_new or health == 0:
			explode()
		else:
			health -= 1
			var newXLocation = position.x + bump_distance
			if area.position.x > position.x:
				newXLocation = position.x - bump_distance
			bump_destination = Vector2(newXLocation, position.y - bump_distance)
			bump_destination_set = true
	elif area is Cannon or "Ground" in area.name:
		explode()

func explode():
	emit_signal("explode", position.x, position.y)
	emit_signal("smartbomb_destroyed")
	queue_free()
