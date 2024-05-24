extends Node2D

@onready var explosionRadius = $ExplosionRadius
@onready var timeUntilExplode:Timer = $TimeUntilExplode
@onready var logSprite = $Sprite2D
@onready var explosionRadiusSprite = $ExplosionRange
var isClone:bool = false

func modulateIfClone(clone:bool):
	isClone = clone
	if(isClone):
		logSprite.modulate.a = 0.5
		explosionRadiusSprite.modulate.a = 0.5

func explode():
	if not isClone:
		for hitObj in explosionRadius.collision_result:
			var player = hitObj.collider

			if player.is_in_group("player"):
				player.takeDamage(10)
			
	queue_free()

func _on_time_until_explode_timeout():
	explode()
