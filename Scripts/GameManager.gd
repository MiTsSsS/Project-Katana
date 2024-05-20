extends Node

const WAVEMANAGER = preload("res://Scenes/World/WaveManager.tscn")

signal spawnEnemy

var waveManager:WaveManager

func endGame():
	get_tree().paused = true
