extends Interactable

@onready var shopUI = $CanvasLayer/PanelContainer

#Shop Functionatily

#Merchant Interact
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
		shopUI.visible = false

func interactedWith():
	shopUI.visible = true
