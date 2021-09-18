extends Node

export (PackedScene) var Main
export (PackedScene) var GameOver
export (PackedScene) var TitleScreen

var highScore = 7500

# Called when the node enters the scene tree for the first time.
func _ready():
	createTitleScreen()

func _on_TitleScreen_start_game():
	var main = Main.instance()
	add_child(main)
	main.set_high_score(highScore)
	main.connect("game_over", self, "_on_Game_Over")

func _on_Game_Over(score):
	var gameOver = GameOver.instance()
	add_child(gameOver)
	gameOver.set_final_score(score)
	if score > highScore:
		highScore = score
	gameOver.connect("back_to_title", self, "_on_Back_To_Title")

func _on_Back_To_Title():
	createTitleScreen()
	
func createTitleScreen():
	var titleScreen = TitleScreen.instance()
	add_child(titleScreen)
	titleScreen.set_high_score(highScore)
	titleScreen.connect("start_game", self, "_on_TitleScreen_start_game")
