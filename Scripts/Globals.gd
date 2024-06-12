extends Node

const NEGATIVEWORLD_X = -800
const WORLD_X = 800
const NEGATIVEWORLD_Y = -800
const WORLD_Y = 800

#Player persistent properties
var hp:int = 100
var maxHp:int = 100
var gold:int = 100
var baseSpeed:int = 500
var speed:int = 500
var dashDuration:float = 0.2
var dashSpeedScalar:float = 1.2
var damage:int = 1000
var player:Player = null
var lastCompletedWave = 0
var currentWave = 1

#UI persistent properties
var shouldShowWaveRelatedUi = true

#Wave persistent properties
var timeUntilNextWave = 4

func updateHp(val):
	hp += val
	player.hp = hp

func updateMaxHp(val):
	maxHp += val
	player.maxHp = maxHp

func heal(val):
	hp += val
	player.heal(val)

func updateGold(val):
	gold += val
	player.gold = gold
	player.goldModified.emit(gold)

func updateBaseSpeed(val):
	baseSpeed += val
	player.baseSpeed = baseSpeed

func updateSpeed(val):
	speed += val
	baseSpeed += val
	player.speed = speed
	player.baseSpeed = baseSpeed

func updateDashCooldown(val):
	dashDuration += val
	player.dashDuration = dashDuration

func updateDamage(val):
	damage += val
	player.damage = damage

func resetDefaults():
	hp = 100
	maxHp = 100
	gold = 100
	baseSpeed = 500
	speed = 500
	dashDuration = 0.2
	dashSpeedScalar = 1.2
	damage = 10
	player = null

func setShouldShowWaveRelatedUi(shouldShow:bool):
	shouldShowWaveRelatedUi = shouldShow

func updateTimeBetweenWaves(newTime:int):
	timeUntilNextWave = newTime
