extends Node

export (PackedScene) var Cannon

var left_cannon_x_location = 48
var middle_cannon_x_location = 400
var right_cannon_x_location = 752
var cannon_y_location = 526
var left_cannon
var middle_cannon
var right_cannon

# Called when the node enters the scene tree for the first time.
func _ready():
	create_cannons()
	
func disable_next_missile():
	if right_cannon.ammo > 0:
		right_cannon.disable_next_missile()
	elif middle_cannon.ammo > 0:
		middle_cannon.disable_next_missile()
	elif left_cannon.ammo > 0:
		left_cannon.disable_next_missile()
	
func get_missile_count():
	return left_cannon.ammo + right_cannon.ammo + middle_cannon.ammo
	
func reload():
	left_cannon.reload()
	middle_cannon.reload()
	right_cannon.reload()

func create_cannons():
	left_cannon = create_cannon(left_cannon_x_location)
	middle_cannon = create_cannon(middle_cannon_x_location)
	right_cannon = create_cannon(right_cannon_x_location)

func create_cannon(x_location):
	var cannon = Cannon.instance()
	add_child(cannon)
	cannon.position = Vector2(x_location, cannon_y_location)
	return cannon
	
func is_closest_to_left(location):
	return location < 224
	
func is_closest_to_right(location):
	return location > 576
	
func try_shoot(destination, controllerNode):
	if is_closest_to_left(destination.x):
		if left_cannon and left_cannon.ammo > 0:
			left_cannon.try_shoot(destination, controllerNode)
		elif middle_cannon and middle_cannon.ammo > 0:
			middle_cannon.try_shoot(destination, controllerNode)
		else:
			right_cannon.try_shoot(destination, controllerNode)
	elif is_closest_to_right(destination.x):
		if right_cannon and right_cannon.ammo > 0:
			right_cannon.try_shoot(destination, controllerNode)
		elif middle_cannon and middle_cannon.ammo > 0:
			middle_cannon.try_shoot(destination, controllerNode)
		else:
			left_cannon.try_shoot(destination, controllerNode)
	else:
		if middle_cannon and middle_cannon.ammo > 0:
			middle_cannon.try_shoot(destination, controllerNode)
		elif destination.x > 400:
			if right_cannon.ammo > 0:
				right_cannon.try_shoot(destination, controllerNode)
			else:
				left_cannon.try_shoot(destination, controllerNode)	
		else:
			if left_cannon.ammo > 0:
				left_cannon.try_shoot(destination, controllerNode)
			else: 
				right_cannon.try_shoot(destination, controllerNode)
