extends Control

func _ready():
	hide()

func _on_restart_btn_button_down():
	SceneTransitioner.restartGame()
