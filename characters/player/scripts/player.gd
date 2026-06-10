@tool
class_name Player
extends CharacterEntity

signal s_game_over

@export_group("Stats")
@export var max_health := 5
@export var current_health := 5
@export var clash_strength := 1

@export_group("Movement variables")
@export var speed := 100:
	set(value):
		speed = value
		tool_update_jump_trayectory()
		
@export var gravity := 300:
	set(value):
		gravity = value
		tool_update_jump_trayectory()

@export var jump_impulse := 200:
	set(value):
		jump_impulse = value
		tool_update_jump_trayectory()

@onready var floor_detection: RayCast2D = $ShouldNotRotate/FloorDetection
@onready var player_animations: AnimatedSprite2D = $ShouldRotate/PlayerAnimations
@onready var hitboxes: Node2D = $ShouldRotate/Hitboxes

@onready var health_amount: Label = $UI/Game/HealthContainer/Amount

@onready var state_machine: PlayerStateMachine = $StateMachine
@onready var pause_menu: Control = $UI/PauseMenu

var pause_trigger := false

func _process(_delta: float) -> void:
	if(!Engine.is_editor_hint()):
		if(Input.is_action_just_pressed("pause")):
			pause_game()
		if(Input.is_action_just_pressed("map")):
			pause_game(1)

func character_ready() -> void:
	health_amount.text = str(current_health)

func enable_gravity(_delta: float):
	velocity.y += gravity * _delta

func enable_x_movement():
	var x_direction = Input.get_axis("left", "right")
	if(x_direction > 0.1):
		turn_right()
	if(x_direction < -0.1):
		turn_left()	
	velocity.x = speed * x_direction

func disable_hitboxes():
	for hitbox: PlayerHitbox in hitboxes.get_children():
		hitbox.disable()	

func death():
	s_game_over.emit()
	queue_free()

func pause_game(tab_position := 0):
	pause_trigger = true
	get_tree().paused = true
	pause_menu.set_menu_position(tab_position)
	pause_menu.show()

# Used in combat resolution
func on_damaged(damage: int, enemy_position: Vector2) -> void:
	current_health -= damage
	if(current_health <= 0):
		death()
	health_amount.text = str(current_health)
	state_machine.on_damaged(damage, enemy_position)

func on_hit() -> void:
	state_machine.on_hit()
		
func on_clash(enemy_collision_position: Vector2) -> void:
	state_machine.on_clash(enemy_collision_position)
