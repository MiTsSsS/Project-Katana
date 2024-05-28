extends Node

const SCENETRANSITION = preload("res://Scenes/UI/Transitions/SceneTransition.tscn")

func transitionFromGameplayToMainMenu():
	var mainMenuPath = load("res://Scenes/UI/Menus/MainMenu.tscn")
	get_node("/root/TestScene").free()
	await transitionFade()
	var mainPacked = mainMenuPath.instantiate()
	add_child(mainPacked)

func restartGame():
	get_node("/root/TestScene").free()
	await transitionFade()

	var gameScenePath = load("res://Scenes/TestScene.tscn")
	var gameScenePacked = gameScenePath.instantiate()
	get_node("/root").add_child(gameScenePacked)
	
func transitionToScene(scenePath):
	await transitionFade()

	if not ResourceLoader.exists(scenePath):
		var newScenePacked = load(scenePath)
		var newScene = newScenePacked.instantiate()
		add_child(newScene)
	else:
		get_tree().change_scene_to_file(scenePath)

func quitGame():
	if get_node("/root/").has_node("/root/TestScene"):
		get_node("/root/TestScene").free()

	await transitionFade()
	get_tree().quit()

func transitionFade():
	var transition = SCENETRANSITION.instantiate()
	add_child(transition)
	await transition.animPlayer.animation_finished
	transition.queue_free()
