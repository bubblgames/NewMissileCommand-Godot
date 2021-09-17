extends CanvasLayer

export (PackedScene) var missileSprite
export (PackedScene) var city

var missileStartPositionX = 406
var missileXincrement = 10
var missileYPosition = 260
var cityStartPositionX = 420
var cityXincrement = 45
var cityYPosition = 304
var missileCount = 0
var cityCount = 0
var missiles = []
var cities = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$EndOfWaveContent/NewCityText.hide()

func show_end_of_wave_content():
	$EndOfWaveContent/MissilesScore.show()
	$EndOfWaveContent/CitiesScore.show()
	$EndOfWaveContent/BonusPoints.show()

func hide_end_of_wave_content():
	for missile in missiles:
		missile.queue_free()
		
	for cityInstance in cities:
		cityInstance.queue_free()
		
	missiles = []
	cities = []
	missileCount = 0
	cityCount = 0
	$EndOfWaveContent/MissilesScore.text = ""
	$EndOfWaveContent/CitiesScore.text = ""
	$EndOfWaveContent/MissilesScore.hide()
	$EndOfWaveContent/CitiesScore.hide()
	$EndOfWaveContent/BonusPoints.hide()
	$EndOfWaveContent/NewCityText.hide()
	
func show_start_of_wave_content(waveNumber, pointsMultiplier):
	$StartWaveAudio.play()
	$StartOfWaveContent/DefendCitiesText.show()
	$StartOfWaveContent/WaveText.show()
	$StartOfWaveContent/WaveText.text = "Wave          " + str(waveNumber)
	$StartOfWaveContent/PointsText.text = str(pointsMultiplier) + "          x          Points"
	$StartOfWaveContent/PointsText.show()
	
func hide_start_of_wave_content():
	$StartOfWaveContent/DefendCitiesText.hide()
	$StartOfWaveContent/WaveText.hide()
	$StartOfWaveContent/PointsText.hide()

func show_next_missile(missileValue):
	var missile = missileSprite.instance()
	add_child(missile)
	missiles.append(missile)
	missile.position = Vector2(missileStartPositionX + missileXincrement*missileCount, missileYPosition)
	missile.scale = Vector2(0.4, 0.3)
	missileCount += 1
	$EndOfWaveContent/MissilesScore.text = str(missileCount * missileValue)
	$PointsCountAudio.play()
	
func show_next_city(cityValue):
	var cityInstance = city.instance()
	cities.append(cityInstance)
	add_child(cityInstance)
	cityInstance.position = Vector2(cityStartPositionX + cityXincrement*cityCount, cityYPosition)
	cityCount += 1
	$EndOfWaveContent/CitiesScore.text = str(cityCount * cityValue)
	$PointsCountAudio.play()
	
func show_new_city():
	$EndOfWaveContent/NewCityText.show()
