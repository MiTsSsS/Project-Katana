extends Node2D

class_name Katana

signal completedCurrentAttackAnimation

enum AppliedSkill {
	NONE,
	FIRE,
	WIND,
	BOOMERANG,
}

#General
@onready var player:Player = get_parent().get_parent()

#Attack related
@onready var comboAttackAnimationSequence = ["swing", "swing1", "swing2"]
@onready var comboAttackIndex = 0
@onready var slashVfx = $SlashVFX

#Skill related
@onready var speed = 800

@onready var appliedSkill = AppliedSkill.WIND
const FIRESKILL = preload("res://Scripts/Abilities/Fire.gd")
const WINDSKILL = preload("res://Scenes/Abilities/Wind.tscn")

@onready var boomerang = false
@onready var shouldBoomerangReturn = false
@onready var boomerangSwirl = $BoomerangSwirl

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_boomerang_travel_time_timeout():
	shouldBoomerangReturn = true
