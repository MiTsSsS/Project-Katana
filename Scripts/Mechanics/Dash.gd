extends Node2D

@onready var durationTimer = $DurationTimer

func startDash(duration):
	durationTimer.wait_time = duration
	if(!isDashing()):
		durationTimer.start()

func isDashing():
	return !durationTimer.is_stopped()
