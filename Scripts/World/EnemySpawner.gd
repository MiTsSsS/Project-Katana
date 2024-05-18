extends Node2D

class_name EnemySpawner

const SAMURAI = preload("res://Scenes/Characters/Enemies/Samurai.tscn")
const ARCHER = preload("res://Scenes/Characters/Enemies/Samurai.tscn")
const HANZO = preload("res://Scenes/Characters/Enemies/Hanzo.tscn")

enum Enemy_Type {SAMURAI, ARCHER, HANZO} 

@export var spawnInterval:int = 5
@onready var spawnIntervalTimer:Timer = $Timer

func _ready():
	GameManager.spawnEnemy.connect(spawnEnemy)
	await get_tree().create_timer(1).timeout
	spawnEnemy(Enemy_Type.SAMURAI)

func spawnEnemy(type:Enemy_Type):
	var enemy

	if type == Enemy_Type.SAMURAI:
		enemy = SAMURAI
	if type == Enemy_Type.HANZO:
		enemy = HANZO
	if type == Enemy_Type.ARCHER:
		enemy = ARCHER
	
	var spawnedEnemy = enemy.instantiate()
	spawnedEnemy.global_position = global_position
	get_parent().add_child(spawnedEnemy)
	spawnIntervalTimer.start()

func _on_timer_timeout():
	spawnIntervalTimer.wait_time = spawnInterval
	spawnEnemy(Enemy_Type.HANZO)
