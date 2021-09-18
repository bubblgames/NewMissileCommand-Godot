extends CanvasLayer

signal start_game
	
func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.pressed:
		emit_signal("start_game")
		queue_free()

func _on_BlinkTimer_timeout():
	if $ClickToStart.is_visible_in_tree():
		$ClickToStart.hide()
	else:
		$ClickToStart.show()
		
func set_high_score(score):
	$HighScore.text = "Hi  Score     " + str(score)
