@tool
class_name Vastago
extends Enemy

@onready var floor_detection: RayCast2D = $ShouldRotate/Raycasts/FloorDetection
@onready var wall_detection: RayCast2D = $ShouldRotate/Raycasts/WallDetection

@export var min_stop_time_secs := 0.2
@export var max_stop_time_secs := 1.0

@export var min_move_time_secs := 1.0
@export var max_move_time_secs := 1.5

@export var clash_strength := 1
@onready var attack_duration: Timer = $StateMachine/Jump/AttackDuration
@onready var cutscene_state_machine: BaseCutsceneStateMachine = $CutsceneStateMachine

@onready var energy_reward: SpiritEnergySpawner = $ShouldNotRotate/EnergyReward

# TODO: Hack so the cutscene state machine works, there is a sprite_animations 
# var in the Enemy class
@onready var entity_animations: AnimatedSprite2D = $ShouldRotate/SpriteAnimations

var floor_colliding := false
var wall_colliding := false

var player_ref : Player = null

func character_ready() -> void:
	energy_reward.s_reward_complete.connect(death)
	sprite_animations.material = sprite_animations.material.duplicate(true)
	sprite_animations.play("idle")

func _physics_process(_delta: float) -> void:
	if(!Engine.is_editor_hint()):
		if(floor_detection.is_colliding()):
			floor_colliding = true
		else:
			floor_colliding = false
		
		if(wall_detection.is_colliding()):
			wall_colliding = true
		else:
			wall_colliding = false

func on_damaged(damage: int, _other_entity_position: Vector2) -> void:
	on_damaged_vfx.play("hit_effect")
	turn_towards(_other_entity_position)
	if(counter_hit_state):
		GlobalVFXs.hitstop(0.2)
		health -= damage * 2
		stamina -= damage * 3
	else:
		GlobalVFXs.hitstop(0.1)
		health -= damage
		stamina -= damage * 2
	if(health <= 0):
		death()
		return
	if(counter_hit_state):
		#Counter hit reaction
		state_machine.transition_to_next_state(state_machine.CLASH, {
			"player_position": _other_entity_position
		})

func on_clash(_other_collision_position: Vector2) -> void:
	stamina -= 1
	GlobalVFXs.hitstop(0.1)
	state_machine.transition_to_next_state(state_machine.CLASH, {
		"player_position": _other_collision_position
	})

func death():
	attack_duration.stop()
	state_machine.transition_to_next_state(state_machine.DEATH)

func is_floor_colliding() -> bool:
	return floor_colliding	

func is_wall_colliding() -> bool:
	return wall_colliding

func enter_cutscene_mode() -> void:
	activate_detection.disable()
	state_machine.deactivate_process()
	cutscene_state_machine.activate_process()
	
func exit_cutscene_mode() -> void:
	state_machine.activate_process()
	state_machine.transition_to_next_state(state_machine.PASSIVE)
	cutscene_state_machine.deactivate_process()
