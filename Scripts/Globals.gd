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
var damage:int = 10
var player:Player = null

func updateHp(val):
	hp += val
	player.hp = hp

func updateMaxHp(val):
	maxHp += val
	player.maxHp = maxHp

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
