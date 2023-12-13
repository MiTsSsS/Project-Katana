extends CharacterBody2D 

class_name Enemy

@onready var hp = 100
@onready var isOnFire = false
@onready var fireSpreadRadius = $FireSpreadShapeCast2D

func _physics_process(delta):
	look_at(get_node("/root/TestScene/Character").get_position())

func takeDamage(damage):
	hp -= damage
	print(hp)
	
	if(hp <= 0):
		queue_free()
		
func setIsOnFire(hasFire):
	isOnFire = hasFire
	
#TODO Figure out a way to enable/disable shape cast.
#TODO Figure out a way to do this process only once
#and not everytime the wind collides with the same enemy.
func spreadFire():
	for hitObj in fireSpreadRadius.collision_result:
		if hitObj.collider.is_in_group("mobs"):
			print("HIIITTTTTTTT")
