extends CharacterBody2D 

func _physics_process(delta):
	look_at(get_node("/root/TestScene/Character").get_position())
