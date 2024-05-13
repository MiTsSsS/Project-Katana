extends Area2D

@export var healVal = 8

func _on_body_entered(body:Node2D):
	if body.is_in_group("player"):
		var hitObj := body as Player
		hitObj.heal(healVal)
		queue_free()

		

