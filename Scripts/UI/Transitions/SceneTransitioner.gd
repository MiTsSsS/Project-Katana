extends Node

const SCENETRANSITION = preload("res://Scenes/UI/Transitions/SceneTransition.tscn")

func transitionToScene(scenePath):
	var transition = SCENETRANSITION.instantiate()
	add_child(transition)
	await transition.animPlayer.animation_finished
	transition.queue_free()

	if not ResourceLoader.exists(scenePath):
		var newScenePacked = load(scenePath)
		var newScene = newScenePacked.instantiate()
		add_child(newScene)
	else:
		get_tree().change_scene_to_file(scenePath)
