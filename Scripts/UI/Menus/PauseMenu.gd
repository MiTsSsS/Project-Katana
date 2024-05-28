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
	get_tree().paused = false

func _on_quit_to_main_menu_btn_button_down():
	hide()
	get_tree().paused = false
	SceneTransitioner.transitionToScene("res://Scenes/UI/Menus/MainMenu.tscn")

func _on_quit_game_btn_button_down():
	get_tree().quit()
