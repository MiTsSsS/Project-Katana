extends CharacterBody2D 

class_name Enemy

enum State {
	IDLE,
	CHASING,
	ATTACKING,
}

@onready var minimapIcon = "enemy"
@onready var isOnFire = false
@onready var fireSpreadRadius = $FireSpreadShapeCast2D
@onready var sprite = $Sprite2D
@onready var targetDistanceToPlayer = 0
@onready var state = State.CHASING
@onready var floatingDamageSpawnRangeMin = -30
@onready var floatingDamageSpawnRangeMax = 30

@onready var hitFlash:ShaderMaterial = $Sprite2D.material
@onready var hpBar:ProgressBar = $CharacterHealthBar

@export var hp:int = 100
@export var testName:String

var fireNode:Fire

const FIRESKILL = preload("res://Scripts/Abilities/Fire.gd")
const FLOATINGDAMAGE = preload("res://Scenes/UI/FloatingText.tscn")

signal enemyDied
signal removed(object)

func _ready():
	hpBar.set_value_no_signal(hp)
	enemyDied.connect(GameManager.waveManager.decrementEnemiesToDefeat)
	removed.connect(GameManager.hudManager.minimap.onObjectRemoved)

func _physics_process(delta):
	pass
	
func setHp(value):
	hp = value
	
	if hp == 0:
		queue_free()

func takeDamage(damage):
	hp -= damage
	hpBar.set_value_no_signal(hp)

	print(hp)
	
	if hp <= 0:
		onDeath()
		queue_free()

	takeDamageVisuals(damage)
		
func onDeath():
	enemyDied.emit()
	removed.emit(self)

func setIsOnFire(hasFire):
	isOnFire = hasFire

func spreadFire():
	for hitObj in fireSpreadRadius.collision_result:
		var enemy = hitObj.collider
		if enemy.is_in_group("mobs"):
			if isOnFire and enemy.isOnFire:
				fireNode.resetBurnDuration()
			elif isOnFire and not enemy.isOnFire:
				var fs = FIRESKILL.new(enemy)
				enemy.add_child(fs)
				enemy.setIsOnFire(true)
			else:
				print("Not one condition is satisfied")

func takeDamageVisuals(damageValue:int):
	hitFlash.set_shader_parameter("active", true)
	await get_tree().create_timer(0.1).timeout
	hitFlash.set_shader_parameter("active", false)
	var fd = FLOATINGDAMAGE.instantiate()
	fd.position.x = randf_range(floatingDamageSpawnRangeMin, floatingDamageSpawnRangeMax)
	add_child(fd)
	fd.updateValue(damageValue)
