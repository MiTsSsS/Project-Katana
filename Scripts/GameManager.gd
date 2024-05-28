extends Node

const WAVEMANAGER = preload("res://Scenes/World/WaveManager.tscn")

signal spawnEnemy

var waveManager:WaveManager
var hudManager:HUDManager

#Pause Menu
signal gamePaused

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS

func _input(event : InputEvent):
	if event.is_action_pressed("ui_cancel"):
		pauseMenuToggle()

func pauseMenuToggle():
	get_tree().paused = not get_tree().paused
	gamePaused.emit(get_tree().paused)

func endGame():
	get_tree().paused = true
