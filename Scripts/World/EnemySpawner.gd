extends Node2D

class_name EnemySpawner

const SAMURAI = preload("res://Scenes/Characters/Enemies/Samurai.tscn")
const ARCHER = preload("res://Scenes/Characters/Enemies/Musketeer.tscn")
const HANZO = preload("res://Scenes/Characters/Enemies/Hanzo.tscn")

enum Enemy_Type {SAMURAI, ARCHER, HANZO} 

@export var spawnInterval:int = 5
@onready var spawnIntervalTimer:Timer = $Timer

func _ready():
	GameManager.spawnEnemy.connect(spawnEnemy)

func getParsedEnemyInfo(samuraiAmountToSpawn, archerAmountToSpawn, hanzoAmountToSpawn):
	for n in samuraiAmountToSpawn:
		spawnEnemy(Enemy_Type.SAMURAI)

	for n in hanzoAmountToSpawn:
		spawnEnemy(Enemy_Type.HANZO)

	for n in archerAmountToSpawn:
		spawnEnemy(Enemy_Type.ARCHER)

func spawnEnemy(type:Enemy_Type):
	var enemy

	if type == Enemy_Type.SAMURAI:
		enemy = SAMURAI
	if type == Enemy_Type.HANZO:
		enemy = HANZO
	if type == Enemy_Type.ARCHER:
		enemy = ARCHER
	
	var spawnedEnemy = enemy.instantiate()
	var randPosX = randf_range(Globals.WORLD_X, Globals.NEGATIVEWORLD_X)
	var randPosY = randf_range(Globals.WORLD_Y, Globals.NEGATIVEWORLD_Y)
	spawnedEnemy.global_position.x = randPosX
	spawnedEnemy.global_position.y = randPosY
	get_parent().get_parent().add_child.call_deferred(spawnedEnemy)
	#spawnIntervalTimer.start()

	#func _on_timer_timeout():
	#spawnIntervalTimer.wait_time = spawnInterval
	#spawnEnemy(Enemy_Type.HANZO)
