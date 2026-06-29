@tool
class_name CursedSlime
extends Enemy

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

func enable_attack_detection() -> void:
	attack_in_range_detection.enable()

func disable_attack_detection() -> void:
	attack_in_range_detection.disable()
