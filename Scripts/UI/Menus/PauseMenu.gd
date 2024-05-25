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
	pass

func _on_quit_to_main_menu_btn_button_down():
	pass

func _on_quit_game_btn_button_down():
	get_tree().quit()
