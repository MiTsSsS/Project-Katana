extends Node

const NEGATIVEWORLD_X = -800
const WORLD_X = 800
const NEGATIVEWORLD_Y = -800
const WORLD_Y = 800

#Player persistent properties
var hp:int = 100
var maxHp:int = 100
var gold:int = 0
var baseSpeed:int = 1000
var speed:int = 1000
var dashDuration:float = 0.2
var dashSpeedScalar:float = 1.2

func updateHp(val):
	hp = val

func updateMaxHp(val):
	maxHp = val

func updateGold(val):
	gold = val

func updateBaseSpeed(val):
	baseSpeed = val

func updateSpeed(val):
	speed = val

func updateDashCooldown(val):
	dashDuration = val
