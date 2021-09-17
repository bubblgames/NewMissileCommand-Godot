extends CanvasLayer

export (PackedScene) var Hexagon

signal back_to_title

var grow_hexagon = true
var scaleIncrement = 0.02
var scaleLimit = 4
var hex
var currentIndex = 0
var theEndText = ["T","H","E"," ", " ", " ", "E", "N", "D"]
var finalScore = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)
	hex = Hexagon.instance()
	add_child(hex)
	hex.position = Vector2(400, 300)
	hex.playing = true
	$FinalScore.hide()
	
func set_final_score(final):
	finalScore = final

func _process(delta):
	if grow_hexagon:
		hex.scale = Vector2(hex.scale.x + scaleIncrement, hex.scale.y + scaleIncrement)
		if hex.scale.x > scaleLimit:
			hex.scale = Vector2(scaleLimit, scaleLimit)
			grow_hexagon = false
			$LetterTimer.start()

func _on_GameOverTimer_timeout():
	emit_signal("back_to_title")
	queue_free()

func _on_LetterTimer_timeout():
	$Holder/TheEnd.text = $Holder/TheEnd.text + theEndText[currentIndex]
	currentIndex +=1
	if currentIndex == theEndText.size():
		$LetterTimer.stop()
	$FinalScore.show()
	$FinalScore.text = "Final Score    " + str(finalScore)
	$GameOverTimer.start()
