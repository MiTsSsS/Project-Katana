extends Node

class_name WaveManager

const ENEMYSPAWNER = preload("res://Scenes/Characters/Enemies/EnemySpawner.tscn") 

var waveNumber = 0
var completedWaves = 1
var enemiesToDefeat = 0
var samuraiAmountToSpawn:int
var archerAmountToSpawn:int
var hanzoAmountToSpawn:int
@onready var enemySpawner:EnemySpawner = $EnemySpawner
var jsonDict

signal enemyAmntDecremented
signal waveCompleted
signal waveStarted #Used to refresh minimap

func _ready():
	parseWaveDataFromJson()
	GameManager.waveManager = self
	enemyAmntDecremented.connect(GameManager.hudManager.updateRemainingEnemies)
	waveCompleted.connect(GameManager.hudManager.updateWavesNumber)
	GameManager.hudManager.setMaxWave(waveNumber)
	completedWaves = Globals.completedWaves
	GameManager.hudManager.setWavesNumber(completedWaves)
	waveStarted.connect(GameManager.hudManager.minimap.updateMinimapMarkers)
	startWave()

func parseWaveDataFromJson():
	var waveData = "res://Scripts/World/WaveData.JSON"
	var json_as_text = FileAccess.get_file_as_string(waveData)
	jsonDict = JSON.parse_string(json_as_text)
	if jsonDict:
		waveNumber = jsonDict["waves"]

func startWave():
	GameManager.hudManager.startCountdownTimer()
	var countdownTimer
	if waveNumber == 3:
		countdownTimer = 4
	else:
		countdownTimer = 60
	await get_tree().create_timer(countdownTimer, false).timeout 

	var waveData = getWaveData(Globals.lastCompletedWave + 1)
	enemiesToDefeat = waveData[1] + waveData[2] + waveData[3]
	enemySpawner.getParsedEnemyInfo(waveData[1], waveData[2], waveData[3])
	enemyAmntDecremented.emit(enemiesToDefeat)
	await get_tree().process_frame
	waveStarted.emit()

func getWaveData(compWaves):	
	var currentWave = "wave" 
	currentWave += str(compWaves)
	print(currentWave)
	var data = [jsonDict["enemyTypePerWave"][currentWave]["Timer"], jsonDict["enemyTypePerWave"][currentWave]["Samurai"],jsonDict["enemyTypePerWave"][currentWave]["Archer"], jsonDict["enemyTypePerWave"][currentWave]["Hanzo"]]
	print(data)

	return data

func decrementEnemiesToDefeat():
	enemiesToDefeat -= 1
	enemyAmntDecremented.emit(enemiesToDefeat)

	if enemiesToDefeat == 0:
		completedWaves += 1
		Globals.lastCompletedWave += 1
		Globals.completedWaves += 1
		waveCompleted.emit()

		if completedWaves > waveNumber:
			GameManager.gameEnded.emit(true)

		startWave()
