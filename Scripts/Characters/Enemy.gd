extends CharacterBody2D 

class_name Enemy

enum State {
	IDLE,
	CHASING,
	ATTACKING,
}

@onready var isOnFire = false
@onready var fireSpreadRadius = $FireSpreadShapeCast2D
@onready var sprite = $Sprite2D
@onready var targetDistanceToPlayer = 0
@onready var state = State.CHASING
@onready var fireMaterial:ShaderMaterial = $Sprite2D.material
@onready var hpBar:ProgressBar = $CharacterHealthBar

@export var hp:int = 100
@export var testName:String

var fireNode:Fire

const FIRESKILL = preload("res://Scripts/Abilities/Fire.gd")

func _ready():
	hpBar.set_value_no_signal()

func _physics_process(delta):
	pass
	#look_at(get_node("/root/TestScene/Character").get_position())
	
func setHp(value):
	hp = value
	
	if hp == 0:
		queue_free()

func takeDamage(damage):
	hp -= damage
	hpBar.set_value_no_signal(hp)

	print(hp)
	
	if hp <= 0:
		queue_free()
		
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

