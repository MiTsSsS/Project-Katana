extends Node2D

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
#@onready var travelTime = 800

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("select_normal_melee"):
		appliedSkill = AppliedSkill.NONE
	if Input.is_action_just_pressed("select_fire_skill"):
		appliedSkill = AppliedSkill.FIRE
	if Input.is_action_just_pressed("select_wind_skill"):
		appliedSkill = AppliedSkill.WIND
	if Input.is_action_just_pressed("select_boomerang_skill"):
		appliedSkill = AppliedSkill.BOOMERANG
		
func _physics_process(delta):
	if boomerang:
		var marker:Marker2D = player.animations.get_node("KatanaSlot")
		if not shouldBoomerangReturn:
			$Blade/CollisionShape2D.disabled = false
			global_position += global_transform.x * speed * delta

		else:
			global_position += global_position.direction_to(player.global_position) * speed * delta
			
			if global_position.distance_to(marker.global_position) < 100:
				boomerang = false
				shouldBoomerangReturn = false
				$Blade/CollisionShape2D.disabled = true
				position = marker.position
				global_position = marker.global_position
				player.canPerformNextAttack = true
				rotation = player.animations.rotation
				reparent(player.animations, true)
				boomerangSwirl.stop()

func _on_blade_body_entered(body):
	if body.is_in_group("mobs"):
		var hitObj := body as Enemy
		hitObj.takeDamage(15)
		if appliedSkill == AppliedSkill.FIRE:
			var fs = FIRESKILL.new(hitObj)
			hitObj.add_child(fs)
			hitObj.fireNode = fs
			hitObj.setIsOnFire(true)

func swing():
	match appliedSkill:
		AppliedSkill.NONE:
			meleeAttack()
			
		AppliedSkill.FIRE:
			meleeAttack()
			
		AppliedSkill.WIND:
			var ws = WINDSKILL.instantiate()
			get_parent().get_parent().get_parent().add_child(ws)
			ws.transform = $WindSpawnPoint.global_transform
			meleeAttack()
			
		AppliedSkill.BOOMERANG:
			reparent(get_parent().get_parent().get_parent(), true)
			$BoomerangTravelTime.start()
			$Blade/CollisionShape2D.disabled = false
			boomerang = true
			boomerangSwirl.play("swirl")
			
	if comboAttackIndex == 1:
		slashVfx.flip_h
	
func meleeAttack():
	slashVfx.show()
	$Blade/Swing.play(comboAttackAnimationSequence[comboAttackIndex])
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

func _on_boomerang_travel_time_timeout():
	shouldBoomerangReturn = true
