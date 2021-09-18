extends Line2D
# Called when the node enters the scene tree for the first time.
var cyclesToPrint = 3
var counter = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if (counter % cyclesToPrint == 0):
		global_position = Vector2(0,0)
		global_rotation = 0
		var point = get_parent().global_position
		add_point(point)
	
	counter += 1
