extends Node

const WAVEMANAGER = preload("res://Scenes/World/WaveManager.tscn")

signal spawnEnemy
signal gameEnded
var hasGameEnded = false

var waveManager:WaveManager
var hudManager:HUDManager

#Pause Menu
signal gamePaused

func _ready():
	process_mode = Node.PROCESS_MODE_ALWAYS
	gameEnded.connect(onGameEnd)

func _input(event : InputEvent):
	if not hasGameEnded and event.is_action_pressed("ui_cancel"):
		pauseMenuToggle()

func pauseMenuToggle():
	get_tree().paused = not get_tree().paused
	gamePaused.emit(get_tree().paused)

func onGameEnd(isVictory):
	hasGameEnded = true
