extends CharacterBody2D 

class_name Enemy

@onready var hp = 100

func _physics_process(delta):
	look_at(get_node("/root/TestScene/Character").get_position())
	
func takeDamage(damage):
	hp -= damage
	print(hp)
	
	if(hp <= 0):
		queue_free()


