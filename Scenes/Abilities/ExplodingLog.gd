extends Node2D

@onready var explosionRadius = $ExplosionRadius
@onready var timeUntilExplode:Timer = $TimeUntilExplode

func explode():
	for hitObj in explosionRadius.collision_result:
		var player = hitObj.collider

		if player.is_in_group("player"):
			player.takeDamage(10)
			
	queue_free()

func _on_time_until_explode_timeout():
	explode()
