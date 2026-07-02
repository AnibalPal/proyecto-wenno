@tool
class_name CursedSlime
extends Enemy

@onready var cutscene_state_machine: CursedSlimeCutsceneStateMachine = $CutsceneStateMachine

@onready var entity_animations: AttackParams = $ShouldRotate/SpriteAnimations

@onready var attack_in_range_detection: EnemyDetection = $ShouldRotate/AreaDetections/AttackInRangeDetection
@onready var floor_detection: RayCast2D = $ShouldRotate/Raycasts/FloorDetection
@onready var wall_detection: RayCast2D = $ShouldRotate/Raycasts/WallDetection

@export_group("Movement vars")
@export var speed := 100

@export_group("Attack stats")
@export var clash_strength := 1
# TODO: add a variable that is a list of fight data, maybe create a resource. 
# for example:
# @export var attack_hitbox: Hitbox
# @export var attack_start_active_frames : int
# @export var attack_end_active_frames : int

func enter_cutscene_mode() -> void:
	activate_detection.disable()
	attack_in_range_detection.disable()
	state_machine.deactivate_process()
	cutscene_state_machine.activate_process()
	
func exit_cutscene_mode() -> void:
	attack_in_range_detection.enable()
	state_machine.activate_process()
	state_machine.transition_to_next_state(state_machine.RUN)
	cutscene_state_machine.deactivate_process()

func enable_attack_detection() -> void:
	attack_in_range_detection.enable()

func disable_attack_detection() -> void:
	attack_in_range_detection.disable()
