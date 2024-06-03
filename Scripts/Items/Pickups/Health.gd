extends Area2D

@onready var minimapIcon = "heal"
@export var healVal = 8

signal removed(object)

func _ready():
	removed.connect(GameManager.hudManager.minimap.onObjectRemoved)

func _on_body_entered(body:Node2D):
	if body.is_in_group("player"):
		var hitObj := body as Player
		hitObj.heal(healVal)
		hitObj.createFloatingText(healVal, Color.GREEN)
		removed.emit(self)
		queue_free()
