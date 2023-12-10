extends CharacterBody2D 

class_name Enemy

func _physics_process(delta):
	look_at(get_node("/root/TestScene/Character").get_position())
