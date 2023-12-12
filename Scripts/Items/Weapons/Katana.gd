extends Node

signal completedCurrentAttackAnimation

enum AppliedSkill {
	NONE,
	FIRE,
	WIND,
	BOOMERANG,
}

@onready var comboAttackAnimationSequence = ["swing", "swing1", "swing2"]
@onready var comboAttackIndex = 0
@onready var slashVfx = $SlashVFX
@onready var appliedSkill = AppliedSkill.FIRE
var fireSkill = preload("res://Scripts/Abilities/Fire.gd")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_blade_body_entered(body):
	if body.is_in_group("mobs"):
		var hitObj := body as Enemy
		match appliedSkill:
			AppliedSkill.NONE:
				hitObj.takeDamage(15)
			AppliedSkill.FIRE:
				var fs = fireSkill.new(hitObj)
				hitObj.add_child(fs)
			#AppliedSkill.WIND:
				#Launch wind from Katana
			#AppliedSkill.BOOMERANG:
				#Throw Katana like boomerang

func swing():
	slashVfx.show()
	$Blade/Swing.play(comboAttackAnimationSequence[comboAttackIndex])
	
	if comboAttackIndex == 1:
		slashVfx.flip_h	
	
	slashVfx.play()

func _on_slash_vfx_animation_finished():
	slashVfx.hide()

func onCurrentAttackCompleted():
	incrementArrayIndex()
	completedCurrentAttackAnimation.emit()
	
func incrementArrayIndex():
	comboAttackIndex = comboAttackIndex + 1
	if comboAttackIndex == comboAttackAnimationSequence.size():
		comboAttackIndex = 0

func resetCombo():
	comboAttackIndex = 0
