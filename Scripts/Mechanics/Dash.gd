extends Node2D

@onready var durationTimer = $DurationTimer
@onready var dashSound = $DashSound

func startDash(duration):
	durationTimer.wait_time = duration
	if(!isDashing()):
		dashSound.play()
		durationTimer.start()

func isDashing():
	return !durationTimer.is_stopped()
