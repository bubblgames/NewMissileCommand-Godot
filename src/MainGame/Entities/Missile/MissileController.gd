extends Node

export (PackedScene) var Missile
export (PackedScene) var Spacecraft
export (PackedScene) var Smartbomb
signal wave_complete

var wave_info = [
	{
		"duration" : 10,
		"speedModifier" : 0.075,
		"waves": [4,4],
		"planes": 0,
		"smartbombs": 0
	},
	{
		"duration" : 9,
		"speedModifier" : 0.12,
		"waves": [4,4,3],
		"planes": 1,
		"smartbombs": 0
	},
	{
		"duration" : 8,
		"speedModifier" : 0.15,
		"waves": [4,4,3],
		"planes": 2,
		"smartbombs": 0
	},
	{
		"duration" : 8,
		"speedModifier" : 0.175,
		"waves": [4,2,4,2],
		"planes": 0,
		"smartbombs": 1
	},
	{
		"duration" : 7,
		"speedModifier" : 0.2,
		"waves": [5,3,4],
		"planes": 1,
		"smartbombs": 0
	},
	{
		"duration" : 7,
		"speedModifier" : 0.2,
		"waves": [2,3,2,1],
		"planes": 3,
		"smartbombs": 4
	},
	{
		"duration" : 6,
		"speedModifier" : 0.22,
		"waves": [4,4,4],
		"planes": 2,
		"smartbombs": 0
	},
	{
		"duration" : 6,
		"speedModifier" : 0.22,
		"waves": [4,4,4],
		"planes": 2,
		"smartbombs": 2
	},
	{
		"duration" : 6,
		"speedModifier" : 0.25,
		"waves": [4,4,3],
		"planes": 1,
		"smartbombs": 2
	},
	{
		"duration" : 5,
		"speedModifier" : 0.25,
		"waves": [4,4,4,4],
		"planes": 3,
		"smartbombs": 3
	}
]
var current_wave = []
var current_index = 0
var rng = RandomNumberGenerator.new()
var wave_has_started = false
var planes_created_for_wave = 0
var smartbombs_created_for_wave = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	rng.randomize()
	
func start_wave(number):
	current_index = 0
	planes_created_for_wave = 0
	smartbombs_created_for_wave = 0
	if wave_info.size() == number:
		get_parent().game_over()
	current_wave = wave_info[number]
	$WaveTimer.start()
	if current_wave["planes"] > 0:
		$PlaneTimer.start()
	if current_wave["smartbombs"] > 0:
		$SmartbombTimer.start()
	wave_has_started = true

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if wave_has_started and current_index == current_wave["waves"].size() and current_wave["planes"] == planes_created_for_wave and current_wave["smartbombs"] == smartbombs_created_for_wave:
		emit_signal("wave_complete")
		wave_has_started = false

func _on_WaveTimer_timeout():
	if current_index != current_wave["waves"].size():
		for i in current_wave["waves"][current_index]:
			var startX = rng.randf_range(0, 800)
			create_missile(Vector2(startX, 0), true)
		current_index += 1
			
func create_missile(location, setupDivide):
	var missile = Missile.instance()
	add_child(missile)
	missile.position = location
	var endX = rng.randf_range(0, 800)
	missile.set_destination(Vector2(endX, 542))
	missile.set_speed_multiplier(current_wave["speedModifier"])
	missile.connect("explode", get_parent(), "_on_Explode")
	missile.connect("missile_destroyed", get_parent(), "_on_missile_destroyed")
	missile.add_to_group("enemy")
	
	if setupDivide:
		missile.setup_divide()

func _on_PlaneTimer_timeout():
	if current_wave["planes"] > planes_created_for_wave:
		create_plane()
		planes_created_for_wave += 1
	else:
		$PlaneTimer.stop()
		
func create_plane():
	var spaceCraft = Spacecraft.instance()
	add_child(spaceCraft)
	var variableY = rng.randf_range(150, 400)
	var starting_x = 816
	var destination_x = -16
	if int(variableY) % 2 == 0:
		starting_x = -16
		destination_x = 816
	spaceCraft.position = Vector2(starting_x, variableY)
	spaceCraft.set_destination(Vector2(destination_x, variableY))
	spaceCraft.connect("explode", get_parent(), "_on_Explode")
	spaceCraft.connect("spacecraft_destroyed", get_parent(), "_on_spacecraft_destroyed")
	
func create_smartbomb(location):
	var smartbomb = Smartbomb.instance()
	add_child(smartbomb)
	smartbomb.position = location
	var endX = rng.randf_range(0, 800)
	smartbomb.set_destination(Vector2(endX, 542))
	smartbomb.connect("explode", get_parent(), "_on_Explode")
	smartbomb.connect("smartbomb_destroyed", get_parent(), "_on_smartbomb_destroyed")
	smartbomb.add_to_group("enemy")

func _on_SmartbombTimer_timeout():
	if current_wave["smartbombs"] > smartbombs_created_for_wave:
		var startX = rng.randf_range(0, 800)
		create_smartbomb(Vector2(startX, 0))
		smartbombs_created_for_wave += 1
	else:
		$SmartbombTimer.stop()
