extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	GameManager.gamePaused.connect(onGamePaused)
	hide()

func onGamePaused(isPaused):
	if isPaused:
		show()
	else:
		hide()

func _on_resume_game_btn_button_down():
	GameManager.pauseMenuToggle()

func _on_restart_game_btn_button_down():
	hide()
	SceneTransitioner.restartGame()

func _on_quit_to_main_menu_btn_button_down():
	hide()
	get_tree().paused = false
	SceneTransitioner.transitionFromGameplayToMainMenu()

func _on_quit_game_btn_button_down():
	hide()
	SceneTransitioner.quitGame()
