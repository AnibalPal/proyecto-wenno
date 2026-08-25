@tool
class_name Enemy
extends CharacterEntity

@export_group("Stats")
@export var health := 1
@export var stamina := 10
@export var attack_damage := 1
@export var energy := 3

@export_group("Movement Related")
@export var speed := 100

@export var gravity := 300

@onready var sprite_animations := $ShouldRotate/SpriteAnimations
@onready var hitboxes := $ShouldRotate/Hitboxes
@onready var hurtboxes := $ShouldRotate/Hurtboxes

# Detection areas
@onready var detections: Node2D = $ShouldRotate/AreaDetections
@onready var activate_detection: EnemyDetection = $ShouldRotate/AreaDetections/ActivateDetection

@onready var state_machine: EnemyStateMachine = $StateMachine

var counter_hit_state := false

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

func on_clash(_other_collision_position: Vector2) -> void:
	pass

func on_hit() -> void:
	pass

# Helper Functions
func disable_hitboxes() -> void:
	for hitbox : EnemyHitbox in hitboxes.get_children():
		hitbox.disable()

func disable_hurtboxes() -> void:
	for hurtbox : EnemyHurtbox in hurtboxes.get_children():
		hurtbox.disable()

func enable_hurtboxes() -> void:
	for hurtbox : EnemyHurtbox in hurtboxes.get_children():
		hurtbox.enable()

func disable_detections() -> void:
	for detection : EnemyDetection in detections.get_children():
		detection.disable()

func enable_activation_detection() -> void:
	activate_detection.enable()

func disable_activation_detection() -> void:
	activate_detection.disable()

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
