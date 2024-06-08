extends Interactable

@onready var collision = $CollisionShape2D

func _ready():
	GameManager.waveManager.waveCompleted.connect(toggleCollision)

func _on_body_entered(body:Node2D):
	if body.is_in_group("player"):
		var player:Player = body as Player
		player.setupInteractionProperties()
		player.interactableObject = self

func _on_body_exited(body:Node2D):
	if body.is_in_group("player"):
		var player:Player = body as Player
		player.setupInteractionProperties()
		player.interactableObject = null

func interactedWith():
	Globals.setShouldShowWaveRelatedUi(false)
	SceneTransitioner.transitionToScene("res://Scenes/World/Merchant.tscn")

func toggleCollision():
	await get_tree().process_frame
	collision.disabled = false
