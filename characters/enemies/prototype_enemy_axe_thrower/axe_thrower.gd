@tool
extends CharacterEntity

@export var health := 1
@export var jump_force := 100
@export var move_speed := 50
@export var gravity := 500
@export var projectile : PackedScene
@export var proyectile_velocity := Vector2(100,-100)

@export var min_distance_to_player := 200

@onready var animated_sprite_2d: AnimatedSprite2D = $ShouldRotate/BodyAnimations
@onready var arm_animations: AnimatedSprite2D = $ShouldRotate/ArmAnimations
@onready var on_damaged_vfx: AnimationPlayer = $VFXs/OnDamagedVFX

@onready var axe_spawn_position: Node2D = $ShouldRotate/AxeSpawnPosition

@onready var jump_cooldown: Timer = $Timers/JumpCooldown
@onready var attack_cooldown: Timer = $Timers/AttackCooldown

enum States {
	PASSIVE,
	AGGRESIVE
}

var player = null
var jump_available := true
var current_state := States.PASSIVE

func character_ready() -> void:
	assert(projectile, "Axe thrower: NO PROJECTILE SET!!")
	if(!Engine.is_editor_hint()):
		animated_sprite_2d.play("idle")

func _physics_process(delta: float) -> void:
	if(!Engine.is_editor_hint()):
		velocity.y += gravity * delta
		handle_state_process()
		move_and_slide()

func instantiate_projectile() -> void:
	if(projectile):
		var instance = projectile.instantiate()
		instance.global_position = axe_spawn_position.global_position
		if(facing_right):
			proyectile_velocity.x = abs(proyectile_velocity.x)
		else:
			proyectile_velocity.x = -abs(proyectile_velocity.x)
		instance.velocity = proyectile_velocity
		get_tree().root.add_child(instance)
		

func jump() -> void:
	attack_cooldown.start()
	if(player):
		var direction_to_player := global_position.direction_to(player.global_position)
		if(direction_to_player.x > 0):
			turn_right()
		else:
			turn_left()
	animated_sprite_2d.play("jump")
	jump_cooldown.start()
	if(player):
		var move_away_from_player = true if abs(global_position.x - player.global_position.x) < min_distance_to_player else false
		var movement_strength_rate := randf_range(0.1, 1)
		var jump_height_strength_rate := randf_range(0.5, 1)
		velocity.y = -jump_force * jump_height_strength_rate
		# Randomize jump pattern x movement
		if(move_away_from_player):
			move_backwards(move_speed * movement_strength_rate)
		else:
			move_forward(move_speed * movement_strength_rate)

func handle_state_process() -> void:
	match current_state:
		States.PASSIVE:
			pass
		States.AGGRESIVE:
			if(is_on_floor() and jump_available):
				animated_sprite_2d.play("jump")
				velocity.x = 0
				jump_available = false
		_:
			pass

func handle_transition(new_state : States) -> void:
	if(new_state == States.PASSIVE):
		animated_sprite_2d.play("jump")
	current_state = new_state 
	
func on_damaged(_damage: int, _other_entity_position: Vector2) -> void:
	on_damaged_vfx.play("on_damaged_effect")
	health -= _damage
	if(health <= 0):
		queue_free()

func on_hit() -> void:
	pass
		
func on_clash(_other_collision_position: Vector2) -> void:
	pass

func _on_player_detection_area_entered(_area: Area2D) -> void:
	player = _area.owner
	handle_transition(States.AGGRESIVE)

func _on_animated_sprite_2d_frame_changed() -> void:
	if(animated_sprite_2d.animation == "jump" and animated_sprite_2d.frame == 3):
		jump()

func _on_arm_animations_frame_changed() -> void:
	if(arm_animations.animation == "attack" and arm_animations.frame == 3):
		instantiate_projectile()

func _on_jump_cooldown_timeout() -> void:
	jump_available = true
	
func _on_attack_cooldown_timeout() -> void:
	if(!is_on_floor()):
		arm_animations.play("attack")
