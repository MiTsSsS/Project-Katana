extends Interactable

func _on_interact_body_entered(body:Node2D):
	if body.is_in_group("player"):
		var player:Player = body as Player
		player.setupInteractionProperties()
		player.interactableObject = self

func _on_interact_body_exited(body:Node2D):
	if body.is_in_group("player"):
		var player:Player = body as Player
		player.setupInteractionProperties()
		player.interactableObject = null

func interactedWith():
	#open shop UI	
	print("player interacted with")
	pass
