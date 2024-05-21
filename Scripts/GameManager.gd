extends Node

const WAVEMANAGER = preload("res://Scenes/World/WaveManager.tscn")

signal spawnEnemy

var waveManager:WaveManager
var hudManager:HUDManager

func endGame():
	get_tree().paused = true
