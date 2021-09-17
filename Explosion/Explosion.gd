extends Area2D

class_name Explosion

var newCount = 0
var maxScale = 2
var scaleIncrement = .015
var is_new = true

func _ready():
	add_to_group("explosion")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if (transform.x.x < maxScale):
		transform.x.x += scaleIncrement
		transform.y.y += scaleIncrement
	else:
		queue_free()
		
	if newCount < 10:
		newCount += 1
	else:
		is_new = false
