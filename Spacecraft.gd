extends Area2D

signal spacecraft_destroyed
signal explode(x,y)

var destination_set = false
var destination = Vector2(0,0)
var MOVE_SPEED = 50

var rng = RandomNumberGenerator.new()
func _ready():
	add_to_group("enemy")
	rng.randomize()
	$MissileTimer.wait_time = rng.randf_range(2, 8)
	$MissileTimer.start()
	
func set_destination(dest):
	destination = dest
	destination_set = true

func _process(delta):
	if (destination_set):
		position = position.move_toward(destination, delta * MOVE_SPEED)
		if (abs(position.x - destination.x) < 1 and abs(position.y - destination.y) < 1):
			queue_free()
			
func _on_MissileTimer_timeout():
	get_parent().create_missile(Vector2(position.x, position.y + 20), true)

func _on_Plane_area_entered(area):
	if "Explosion" in area.name:
		explode()
	
func explode():
	emit_signal("explode", position.x, position.y)
	emit_signal("spacecraft_destroyed")
	queue_free()
