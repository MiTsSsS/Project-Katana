extends Area2D

@onready var value:int = 0

func _ready():
	value = randi_range(5, 15)	

func _on_body_entered(body:Node2D):
	if body.is_in_group("player"):
		var player:Player = body as Player
		player.modifyGold(value)
		queue_free()
