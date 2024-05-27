extends Control

const MAINSCENE = preload("res://Scenes/TestScene.tscn")
const SCENETRANSITION = preload("res://Scenes/UI/Transitions/SceneTransition.tscn")

@onready var panelContainer = $PanelContainer

func _on_start_game_btn_button_down():	
	SceneTransitioner.transitionToScene("res://Scenes/TestScene.tscn")
	panelContainer.visible = false
	
func _on_quit_btn_button_down():
	get_tree().quit()
