extends Node

const WAVEMANAGER = preload("res://Scenes/World/WaveManager.tscn")

signal spawnEnemy

var waveManager:WaveManager
var hudManager:HUDManager

func _ready():
	pass

func endGame():
	get_tree().paused = true
