extends Area2D

@onready var windVfx = $WindSlash
@onready var windDuration = $WindDuration
@onready var speed = 300
@onready var hasSpreadFire = false

func _ready():
	windDuration.start()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.x * speed * delta
	
func _on_body_entered(body):
	if body.is_in_group("mobs"):
		var hit := body as Enemy
		hit.position += transform.x * speed * 0.1
		if not hasSpreadFire:	
			print(hit.testName)
			hit.spreadFire()
			hasSpreadFire = true

		
func _on_wind_duration_timeout():
	queue_free()
