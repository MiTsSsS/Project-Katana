extends Area2D

const speed = 800
const FIRESKILL = preload("res://Scripts/Abilities/Fire.gd")
const WINDSKILL = preload("res://Scenes/Abilities/Wind.tscn")
const FIRETRAIL = preload("res://Scenes/Abilities/FireTrail.tscn")

@onready var travelTime = $BoomerangTravelTime
@onready var windCooldown = $WindCooldown
@onready var shouldBoomerangReturn = false

signal signalArrival

var applyFire = false
var createWind = false
var playerPosition

func _ready():
	travelTime.start()
	windCooldown.start()

func  _physics_process(delta):
	if not shouldBoomerangReturn:
		global_position += global_transform.x * speed * delta
	else: 
		global_position += global_position.direction_to(playerPosition) * speed * delta

		if global_position.distance_to(playerPosition) < 50:
			signalArrival.emit()
			queue_free()

	if applyFire:
		var fireTrail = FIRETRAIL.instantiate()
		fireTrail.global_position = global_position
		get_parent().add_child(fireTrail)
		
			
func updatePlayerPosition(newPos:Vector2):
	playerPosition = newPos
	
func _on_boomerang_travel_time_timeout():
	shouldBoomerangReturn = true

func _on_body_entered(body):
	if body.is_in_group("mobs"):
		var hit:Enemy = body
		hit.takeDamage(15)
		
		if applyFire:
			var fs = FIRESKILL.new(hit)
			hit.add_child(fs)
			hit.fireNode = fs
			hit.setIsOnFire(true)
			
func setApplyFire(isActive:bool):
	applyFire = isActive

func setCreateWind(isActive:bool):
	createWind = isActive

func _on_wind_cooldown_timeout():
	windCooldown.wait_time = 1.5
	
	if createWind:
		var ws = WINDSKILL.instantiate()
		get_parent().add_child(ws)
		ws.transform = global_transform
	
	windCooldown.start()
