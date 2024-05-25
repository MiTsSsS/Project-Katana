extends Node

const SCENETRANSITION = preload("res://Scenes/UI/Transitions/SceneTransition.tscn")

func transitionToScene(scenePath):
	var transition = SCENETRANSITION.instantiate()
	add_child(transition)
	await transition.animPlayer.animation_finished
	transition.queue_free()
	var newScenePacked = load(scenePath)
	var newScene = newScenePacked.instantiate()
	add_child(newScene)
