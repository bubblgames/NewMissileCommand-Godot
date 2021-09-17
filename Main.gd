extends Node

signal game_over(score)

var score = 0
var game_running = false
var process_for_level_complete = false
var current_wave = 0
var missileValue = 5
var enemyMissileValue = 25
var cityValue = 100
var spacecraftValue = 100
var smartbombValue = 125
var wait_for_next_round = true
var roundMultiplier = [1,1,2,2,3,3,4,4,5,5,6,6]
var totalNumberOfWaves = 10
var freeCities = 0
var high_score = 0

export (PackedScene) var MissileMob
export (PackedScene) var Explosion
export (StreamTexture) var mouseImage

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_default_cursor_shape(Input.CURSOR_CROSS)
	score = 0
	game_running = true
	$CityController._try_create_cities(6)
	start_next_round()
	$HUD.hide_end_of_wave_content()
	
func set_high_score(highScore):
	high_score = highScore

func start_next_round():
	$StartWaveTimer.start()
	$CannonController.reload()
	$CityController.show_cities()
	$HUD.show_start_of_wave_content(current_wave + 1, roundMultiplier[current_wave])
	
func round_begin():
	$MissileController.start_wave(current_wave)
	$HUD.hide_start_of_wave_content()
	wait_for_next_round = false

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		if game_running && not wait_for_next_round:
			$CannonController.try_shoot(event.position, self)

func _process(delta):
	if process_for_level_complete:
		if get_tree().get_nodes_in_group("enemy").size() == 0:
			wait_for_next_round = true
			if get_tree().get_nodes_in_group("explosion").size() == 0:
				$EndOfRoundTimer.start()
				process_for_level_complete = false
	$HUD/CurrentScore.text = str(score)
	$HUD/HighScore.text = str(high_score)
	
func _on_Explode(x, y):
	var explosion = Explosion.instance()
	call_deferred("add_child", explosion)
	explosion.position = Vector2(x, y)
	$Audio/Explosion.play()
		
func game_over():
	game_running = false
	get_tree().call_group("enemy", "queue_free")
	get_tree().call_group("missiles", "queue_free")
	get_tree().call_group("explosions", "queue_free")
	emit_signal("game_over", score)
	queue_free()

func _on_CityCreator_no_cities():
	$GameOverTimer.start()

func _on_MissileController_wave_complete():
	process_for_level_complete = true
	
func _on_missile_destroyed():
	score += enemyMissileValue
	if score > high_score:
			high_score = score

func _on_smartbomb_destroyed():
	score += smartbombValue
	if score > high_score:
			high_score = score
	
func _on_spacecraft_destroyed():
	score += spacecraftValue
	if score > high_score:
			high_score = score

func _on_StartWaveTimer_timeout():
	round_begin()
	$StartWaveTimer.stop()

func _on_EndWaveTimer_timeout():
	current_wave += 1
	$EndWaveTimer.stop()
	$HUD.hide_end_of_wave_content()
	if current_wave == totalNumberOfWaves:
		game_over()
	start_next_round()

func _on_MissileCountTimer_timeout():
	var missileCount = $CannonController.get_missile_count()
	var cityCount = $CityController.numberOfCities
	if missileCount > 0:
		$CannonController.disable_next_missile()
		$HUD.show_next_missile(missileValue * roundMultiplier[current_wave])
		score += missileValue * roundMultiplier[current_wave]
		if score > high_score:
			high_score = score
	else:
		$MissileCountTimer.stop()
		$CityCountTimer.start()

func _on_CityCountTimer_timeout():
	var cityCount = $CityController.get_visible_cities()
	if cityCount > 0:
		$CityController.disable_next_city()
		$HUD.show_next_city(cityValue * roundMultiplier[current_wave])
		score += cityValue * roundMultiplier[current_wave]
		if score > high_score:
			high_score = score
	else:
		$CityCountTimer.stop()
		if (score / 10000) > freeCities and $CityController.numberOfCities < 6:
			$CityController.create_and_hide()
			$CityCreationTimer.start()
			$CityCreationAudio.play()
			$HUD.show_new_city()
			freeCities += 1
		else:
			$EndWaveTimer.start()

func _on_EndOfRoundTimer_timeout():
	$HUD.show_end_of_wave_content()
	$MissileCountTimer.start()
	$EndOfRoundTimer.stop()

func _on_GameOverTimer_timeout():
	game_over()
	$GameOverTimer.stop() # Replace with function body.

func _on_CityCreationTimer_timeout():
	$CityCreationTimer.stop()
	$EndWaveTimer.start()
