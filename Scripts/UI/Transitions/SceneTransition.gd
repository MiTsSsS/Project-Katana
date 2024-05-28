extends Control

@onready var animPlayer = $AnimationPlayer
@onready var rect = $SceneTransitionRect

func _ready():
	anchorRect()

func anchorRect():
	rect.set_anchors_preset(15)
