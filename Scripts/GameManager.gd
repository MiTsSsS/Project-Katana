extends Node

const WAVEMANAGER = preload("res://Scenes/World/WaveManager.tscn")

signal spawnEnemy

var waveManager:WaveManager
var hudManager:HUDManager

#Pause Menu
signal gamePaused

func _input(event : InputEvent):
	if event.is_action_pressed("ui_cancel"):
		pauseMenuToggle()

func pauseMenuToggle():
	get_tree().paused = not get_tree().paused
	gamePaused.emit(get_tree().paused)
	if get_tree().paused:
		process_mode = Node.PROCESS_MODE_WHEN_PAUSED
	else:
		process_mode = Node.PROCESS_MODE_INHERIT

func endGame():
	get_tree().paused = true
