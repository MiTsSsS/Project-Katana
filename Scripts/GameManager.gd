extends Node

const waveManagerScript = preload("res://Scripts/World/WaveManager.gd")
var waveManager:WaveManager

signal spawnEnemy

func _ready():
	waveManager = waveManagerScript.new()
	waveManager.createSpawner()

func endGame():
	get_tree().paused = true
