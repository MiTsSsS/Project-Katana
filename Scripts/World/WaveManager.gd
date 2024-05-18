extends Node

class_name WaveManager

const ENEMYSPAWNER = preload("res://Scenes/Characters/Enemies/EnemySpawner.tscn") 

var waveNumber = 0
var enemiesToDefeat = 5
var samuraiAmountToSpawn:int
var archerAmountToSpawn:int
var hanzoAmountToSpawn:int
var enemySpawner:EnemySpawner
var wave1Data

func _init():
	parseWaveDataFromJson()

func parseWaveDataFromJson():
	var waveData = "res://Scripts/World/WaveData.JSON"
	var json_as_text = FileAccess.get_file_as_string(waveData)
	var jsonDict = JSON.parse_string(json_as_text)
	if jsonDict:
		waveNumber = jsonDict["waves"]
		wave1Data = [jsonDict["enemyTypePerWave"]["wave1"]["Samurai"],jsonDict["enemyTypePerWave"]["wave1"]["Archer"], jsonDict["enemyTypePerWave"]["wave1"]["Hanzo"]]
		samuraiAmountToSpawn = wave1Data[0]
		archerAmountToSpawn = wave1Data[1]
		hanzoAmountToSpawn = wave1Data[2]

func createSpawner():
	var spawner = ENEMYSPAWNER.instantiate()
	spawner.global_position = Vector2(0, 0)
	get_tree().add_child(spawner)
	enemySpawner = spawner

	for n in samuraiAmountToSpawn:
		enemySpawner.spawnEnemy(EnemySpawner.Enemy_Type.SAMURAI)

func decrementEnemiesToDefeat():
	enemiesToDefeat -= 1

	if enemiesToDefeat == 0:
		get_tree().paused = true
