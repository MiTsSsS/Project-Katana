extends Control

const MAINSCENE = preload("res://Scenes/TestScene.tscn")
const SCENETRANSITION = preload("res://Scenes/UI/Transitions/SceneTransition.tscn")

@onready var panelContainer = $PanelContainer

func _on_start_game_btn_button_down():	
	var mainScene = MAINSCENE.instantiate()
	var transition = SCENETRANSITION.instantiate()
	add_child(transition)
	await transition.animPlayer.animation_finished
	transition.queue_free()
	get_tree().root.add_child(mainScene)
	panelContainer.visible = false
	
func _on_quit_btn_button_down():
	get_tree().quit()
