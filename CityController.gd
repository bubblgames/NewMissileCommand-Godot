extends Node

signal no_cities

export (PackedScene) var City

var city_x_locations = [148, 222, 296, 500, 574, 648]
var city_y_location = 526
var numberOfCities = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
func disable_next_city():
	for city in get_tree().get_nodes_in_group("city"):
		if city.is_visible():
			city.hide()
			break

func get_visible_cities():
	var visible_cities = 0
	for city in get_tree().get_nodes_in_group("city"):
		if city.is_visible():
			visible_cities += 1
			
	return visible_cities

func show_cities():
	for city in get_tree().get_nodes_in_group("city"):
		city.show()
		
func create_and_hide():
	for x_location in city_x_locations:
		var location_exists = false
		for city in get_tree().get_nodes_in_group("city"):
			if city.position.x == x_location:
				location_exists = true
				break
		if not location_exists:
			var city = create_city_at_location(Vector2(x_location, city_y_location))
			city.hide()
			break

func _try_create_cities(numberOfCitiesToCreate):
	var createdCities = 0
	for x_location in city_x_locations:
		if createdCities == numberOfCitiesToCreate:
			break
		var location_exists = false
		for city in get_tree().get_nodes_in_group("city"):
			if city.position.x == x_location:
				location_exists = true
				break
		if not location_exists:	
			create_city_at_location(Vector2(x_location, city_y_location))
			createdCities += 1
		
func create_city(index):
	create_city_at_location(Vector2(city_x_locations[index], city_y_location))

func create_city_at_location(location):
	var city = City.instance()
	city.position = location
	add_child(city)
	city.add_to_group("city")
	numberOfCities += 1
	city.connect("city_hit", self, "_on_City_Hit")
	return city
	
func _on_City_Hit():
	numberOfCities -= 1
	if (numberOfCities == 0):
		emit_signal("no_cities")
	
