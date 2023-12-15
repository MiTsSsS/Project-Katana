extends CharacterBody2D 

class_name Enemy

@onready var hp = 100
@onready var isOnFire = false
@onready var fireSpreadRadius = $FireSpreadShapeCast2D

@export var testName:String

var fireNode:Fire

const FIRESKILL = preload("res://Scripts/Abilities/Fire.gd")

func _physics_process(delta):
	look_at(get_node("/root/TestScene/Character").get_position())

func takeDamage(damage):
	hp -= damage
	print(hp)
	
	if(hp <= 0):
		queue_free()
		
func setIsOnFire(hasFire):
	isOnFire = hasFire
	
#TODO Store currently active fire node inside enemy class
# and then reset its timer when spreading fire
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
	
