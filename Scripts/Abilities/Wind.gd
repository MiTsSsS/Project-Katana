extends Area2D

@onready var windVfx = $WindSlash
@onready var speed = 800

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.x * speed * delta
	
func _on_body_entered(body):
	if body.is_in_group("mobs"):
		var hit := body as Enemy
		hit.position += transform.x * speed * 0.1
