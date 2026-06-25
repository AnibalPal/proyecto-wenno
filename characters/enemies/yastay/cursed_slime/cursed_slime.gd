@tool
class_name CursedSlime
extends Enemy

@onready var attack_in_range_detection: EnemyDetection = $ShouldRotate/Detections/AttackInRangeDetection
@onready var floor_detection: RayCast2D = $ShouldNotRotate/FloorDetection
@onready var wall_detection: RayCast2D = $ShouldNotRotate/WallDetection

@export_group("Movement vars")
@export var speed := 100

@export_group("Attack stats")
# TODO: add a variable that is a list of fight data, maybe create a resource. 
# for example:
# @export var attack_hitbox: Hitbox
# @export var attack_start_active_frames : int
# @export var attack_end_active_frames : int


# Functions to override
func character_ready() -> void:
	# PATCH: Add this line to allow copy pasting without repeating the effect when an enemy is hit
	sprite_animations.material = sprite_animations.material.duplicate(true)

func _physics_process(_delta: float) -> void:
	pass

func on_damaged(damage: int, _other_entity_position: Vector2) -> void:
	if(counter_hit_state):
		health -= damage * 2
		stamina -= damage * 3
	else:
		health -= damage
		stamina -= damage * 2
	if(health <= 0):
		death()
		return
	if(stamina <= 0):
		no_stamina_reaction()

func no_stamina_reaction():
	# Usually go into a stunned state
	pass

func death():
	# Call a death animation and do whatever else is needed
	queue_free()

func enable_attack_detection() -> void:
	attack_in_range_detection.enable()

func disable_attack_detection() -> void:
	attack_in_range_detection.disable()

func on_clash(_other_collision_position: Vector2) -> void:
	pass

func on_hit() -> void:
	pass

func set_counter_state(value: bool) -> void:
	if(Settings.counter_state_aura):
		sprite_animations.material.set_shader_parameter("counter_state", value)
	counter_hit_state = value
	
func turn_towards(objective_position: Vector2) -> void:
	var move_direction := global_position.direction_to(objective_position)
	if(move_direction.x < 0):
		turn_left()
	else:
		turn_right()
		
func enable_gravity(_delta: float):
	velocity.y += gravity * _delta
