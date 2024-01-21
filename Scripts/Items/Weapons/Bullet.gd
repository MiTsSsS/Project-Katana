extends Area2D

@export var speed = 750

func _physics_process(delta):
	position += transform.x * speed * delta
	
	if position.x > Globals.WORLD_X or position.x < Globals.WORLD_X or position.y > Globals.WORLD_Y or position.y < Globals.WORLD_Y:
		queue_free() 

func _on_body_entered(body):
	if body.is_in_group("player"):
		var hit:Player = body
		hit.takeDamage(10)
		queue_free()
