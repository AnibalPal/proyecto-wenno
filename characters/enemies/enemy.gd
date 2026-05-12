@tool
class_name Enemy 
extends CharacterEntity

# Create a state machine with all states in variables instead of the usual state machine pattern
# if the entity is small, a rule of thumb would be to use the big state machine pattern on bosses
# and use the simple state machine pattern for common enemies. For this simple enemy I will put
# all needed code here, then maybe refactor it depending on the needs of the project

@export var health := 1
@export var speed := 100
@export var gravity := 300 

@onready var hitbox: EnemyHitBox = $ShouldRotate/EnemyHitbox
@onready var hurtbox: EnemyHurtBox = $ShouldRotate/EnemyHurtbox
@onready var wall_detection: RayCast2D = $ShouldRotate/WallDetection
@onready var floor_detection: RayCast2D = $ShouldRotate/FloorDetection
@onready var sprite_animations: AnimatedSprite2D = $ShouldRotate/SpriteAnimations
@onready var player_detection_collision: CollisionShape2D = $ShouldRotate/PlayerDetection/CollisionShape2D
@onready var vfx: AnimationPlayer = $VFX

@onready var attack_cooldown : Timer = $Timers/AttackCooldown

@onready var stunned_duration: Timer = $Timers/StunnedDuration
@onready var stunned_slowdown_rate := 0.9
@onready var counter_pushback_rate := 3

@onready var recoil_duration: Timer = $Timers/RecoilDuration
@onready var clash_slowdown_rate := 0.95
@onready var clash_pushback_rate := 4

var vulnerable := false

enum States {
	IDLE,
	MOVE,
	ATTACK,
	STUNNED,
	DEATH,
	RECOIL
}

var current_state := States.MOVE

func _ready() -> void:
	if(!Engine.is_editor_hint()):
		# PATCH: Add this line to allow copy pasting without repeating the effect when an enemy is hit
		sprite_animations.material = sprite_animations.material.duplicate(true)
		sprite_animations.play("run")

func _physics_process(_delta: float) -> void:
	if(Engine.is_editor_hint()):
		pass
	else:
		velocity.y += gravity * _delta
		handle_state_process()
		move_and_slide()

func handle_state_process() -> void:
	match current_state:
		States.IDLE:
			pass
		States.MOVE:
			if(facing_right):
				velocity.x = speed
			else:
				velocity.x = -speed
			if(wall_detection.is_colliding()):
				turn_around()
			if(is_on_floor() and !floor_detection.is_colliding()):
				turn_around()
		States.ATTACK:
			pass
		States.STUNNED:
			velocity.x *= stunned_slowdown_rate
		States.DEATH:
			velocity.x = 0.0
			pass
		States.RECOIL:
			velocity.x *= clash_slowdown_rate
			if(is_equal_approx(velocity.x, 0)):
				handle_transition(States.MOVE)
			pass
		_:
			pass
		

func handle_transition(new_state : States) -> void:
	if(health <= 0 or new_state == States.DEATH):
		hitbox.disable()
		hurtbox.disable()
		player_detection_collision.set_deferred("disabled", true)
		stunned_duration.stop()
		sprite_animations.play("death")
		current_state = States.DEATH
		return
	if(new_state == States.ATTACK):
		player_detection_collision.set_deferred("disabled", true)
		velocity = Vector2.ZERO
		vulnerable = true
		sprite_animations.play("attack")
	if(new_state == States.MOVE):
		hitbox.disable()
		attack_cooldown.start()
		vulnerable = false
		sprite_animations.play("run")
	if(new_state == States.STUNNED):
		stunned_duration.start()
		hitbox.disable()
		player_detection_collision.set_deferred("disabled", true)
		vulnerable = false
		sprite_animations.play("stunned")
	if(new_state == States.RECOIL):
		recoil_duration.start()
		hitbox.disable()
		player_detection_collision.set_deferred("disabled", true)
		vulnerable = false
		sprite_animations.play("recoil")
	current_state = new_state

func on_damaged(damage, attacker_position) -> void:
	vfx.play("hit_effect")
	if(vulnerable):
		GlobalVFXs.hitstop()
		var direction = global_position.direction_to(attacker_position)
		if(direction.x > 0): 
			turn_right()
			velocity.x = -float(speed) * counter_pushback_rate
		else:
			turn_left()
			velocity.x = float(speed) * counter_pushback_rate
		handle_transition(States.STUNNED)
		health -= damage * 2
	else:
		health -= damage
	if(health <= 0):
		handle_transition(States.DEATH)

func on_hit() -> void:
	pass

func on_clash(other_position: Vector2) -> void:
	var direction = global_position.direction_to(other_position)
	if(direction.x > 0): 
		turn_right()
		velocity.x = -float(speed) * clash_pushback_rate
	else:
		turn_left()
		velocity.x = float(speed) * clash_pushback_rate
	handle_transition(States.RECOIL)
	

func _on_player_detection_area_entered(_area: Area2D) -> void:
	if(CombatManager.verify_area_detection(global_position, _area.global_position)):
		return
	handle_transition(States.ATTACK)

func _on_sprite_animations_frame_changed() -> void:
	if(!Engine.is_editor_hint()):
		if(sprite_animations.animation == "attack"):
			if(sprite_animations.frame == 2):
				if(facing_right):
					velocity.x = speed * 5
				else:
					velocity.x = -speed * 5
				hitbox.enable()
			else:
				velocity.x = 0
				hitbox.disable()

func _on_sprite_animations_animation_finished() -> void:
	if(!Engine.is_editor_hint()):
		if(sprite_animations.animation == "death"):
			queue_free()
		if(sprite_animations.animation == "attack"):
			handle_transition(States.MOVE)

func _on_enemy_hurtbox_area_entered(_area: Area2D) -> void:
	pass
	#if(!Engine.is_editor_hint()):
		#if(_area is PlayerHitBox):
			#on_damaged(_area)

func _on_enemy_hitbox_area_entered(_area: Area2D) -> void:
	pass
	#if(!Engine.is_editor_hint()):
		#if(_area is PlayerHitBox):
			## Only the player can subscribe clash events
			#on_clash(_area)


func _on_stunned_duration_timeout() -> void:
	if(!Engine.is_editor_hint()):
		handle_transition(States.MOVE)

func _on_recoil_duration_timeout() -> void:
	if(!Engine.is_editor_hint()):
		handle_transition(States.MOVE)

func _on_attack_cooldown_timeout() -> void:
	player_detection_collision.set_deferred("disabled", false)














# Code from another project that might be useful here
## Functionality that should be shared amongst all enemies
#class_name IEnemy extends CharacterBody2D
#
#@export var health: int = 1
#@export var active := true
#@export var show_health_bar := false
#
#@onready var sprite_animations: AnimatedSprite2D = $SpriteAnimations
#@onready var hit_vfx: AnimationPlayer = $HitVFX
#@onready var world_collision: CollisionShape2D = $WorldCollision
#@onready var hitboxes: Node2D = $Hitboxes
#@onready var hurtboxes: Node2D = $Hurtboxes
#@onready var timers: Node = $Timers
#@onready var player_detection_area: Area2D = get_node_or_null("PlayerDetectionArea")
#
#enum DIRECTIONS {
	#LEFT = -1,
	#RIGHT = 1,
#}
#
#var direction := DIRECTIONS.RIGHT
#var vulnerable := false
#var health_bar = null
#
## Functions to override
#func enemy_ready() -> void:
	#pass
#
#func enemy_process(_delta: float) -> void:
	#pass
#
#func enemy_vulnerable_start() -> void:
	#pass
#
#func enemy_vulnerable_end() -> void:
	#pass
#
#func enemy_death() -> void:
	#pass
#
## Custom behavior when enemy gets hit
#func enemy_hit(_area: Area2D) -> void:
	#pass
#
## Custom behavior when enemy gets blocked (for physical attacks only)
#func enemy_recoil() -> void:
	#pass
#
## Custom behavior when enemy gets hit in a vulnerable state
#func enemy_vulnerable_hit() -> void:
	#pass
#
#func inactive_process(_delta: float) -> void:
	#pass
## ---------------------------------------------
#
## Do some checks on the node structure so that the enemy can work properly, also connect some signals for the hit and death animations
## hit: reduce health, play the "hit" VFX. TODO: add SFX and the option to add an animation / custom hit effect (like enemy being pushed back when attacked)
#func _ready() -> void:
	#assert(sprite_animations, "Enemy requires an AnimatedSprite2D type node named SpriteAnimations to work")
	#assert(hitboxes, "Enemy requires a Node2D type node named Hitboxes")
	#assert(hurtboxes, "Enemy requires a Node2D type node named Hurtboxes")
	#
	#if (show_health_bar):
		#health_bar = $"HealthBar"
		#health_bar.visible = true
		#health_bar.max_value = health
		#health_bar.value = health
#
	## PATCH: Add this line to allow copy pasting without repeating the effect when an enemy is hit
	#sprite_animations.material = sprite_animations.material.duplicate(true)
	#
	#sprite_animations.animation_finished.connect(_on_death_animation_finished)
	#for hurtbox_area: Area2D in hurtboxes.get_children():
		#hurtbox_area.area_entered.connect(_on_hurtbox_area_entered)
	#
	#for hitbox_area: Area2D in hitboxes.get_children():
		#hitbox_area.area_entered.connect(_on_hitbox_area_entered)
#
	## Set direction to the direction set on the editor based on the scale
	## REMEMBER TO USE TRANSFORM INSTEAD OF SCALE
	#set_direction(int_to_dir(sign(transform.x.x)))
#
	#enemy_ready()
#
#func deactivate_areas():
	## NOTE: when I use hitbox_area.set_deferred("monitoring", false) and or hitbox_area.set_deferred("monitorable", false)
	## the slash effect plays twice
	## should optimize this when I get the chance (or will) 
	#for hitbox_area: Area2D in hitboxes.get_children():
		#for hitbox_collision2D: CollisionShape2D in hitbox_area.get_children(): 
			#hitbox_collision2D.set_deferred("disabled", true)
		## hitbox_area.set_deferred("monitoring", false)
		## hitbox_area.set_deferred("monitorable", false)
	#for hurtbox_area: Area2D in hurtboxes.get_children():
		#for hurtbox_collision2D: CollisionShape2D in hurtbox_area.get_children(): 
			#hurtbox_collision2D.set_deferred("disabled", true)
		## hurtbox_area.set_deferred("monitoring", false)
		## hurtbox_area.set_deferred("monitorable", false)
	## NOTE: this assumes that only one player_detection area could be available, this
	## might change in the future if some enemy has detections
	#if(player_detection_area):
		#var player_detection_area_collision = player_detection_area.get_child(0)
		#if(player_detection_area_collision):
			#player_detection_area_collision.set_deferred("disabled", true)
#
#func stop_timers():
	#for timer: Timer in timers.get_children():
		#timer.stop()
#
#func activate_areas():
	#for hitbox_area: Area2D in hitboxes.get_children():
		#for hitbox_collision2D: CollisionShape2D in hitbox_area.get_children(): 
			#hitbox_collision2D.set_deferred("disabled", false)
	#for hurtbox_area: Area2D in hurtboxes.get_children():
		#for hurtbox_collision2D: CollisionShape2D in hurtbox_area.get_children(): 
			#hurtbox_collision2D.set_deferred("disabled", false)
#
## Override in script for custom effects
#func death() -> void:
	#stop_timers()
	#deactivate_areas()
	#active = false
	#sprite_animations.play("death")
	#enemy_death()
#
#func start_vulnerable() -> void:
	#vulnerable = true
	#sprite_animations.material.set_shader_parameter("active_vulnerable", true)
	#enemy_vulnerable_start()
#
#func end_vulnerable() -> void:
	#vulnerable = false
	#sprite_animations.material.set_shader_parameter("active_vulnerable", false)
	#enemy_vulnerable_end()
#
#func hit(damage: int, _area: Area2D) -> void:
	#hit_vfx.play("hit_effect")
	#health -= damage
	#if health_bar:
		#health_bar.value -= damage
	#enemy_hit(_area)
#
#func vulnerable_hit(damage: int) -> void:
	#hit_vfx.play("hit_effect")
	#health -= damage
	#if health_bar:
		#health_bar.value -= damage
	#enemy_vulnerable_hit()
#
## --------------------------------------
#
#func _process(_delta: float) -> void:
	#if (active):
		#if(health <= 0):
			#death()
		#else:
			#enemy_process(_delta)
	#else:
		#inactive_process(_delta)
#
#func _on_death_animation_finished():
	#if sprite_animations.animation == "death":
		#queue_free()
#
#func _on_hitbox_area_entered(area: Area2D):
	#if area.name == "ShieldBox":
		#enemy_recoil()
#
#func _on_hurtbox_area_entered(area: Area2D):
	#if area.has_method("get_damage"):
		#if(vulnerable):
			#vulnerable_hit(area.get_damage() * 3)
		#else:
			#hit(area.get_damage(), area)
	#else:
		#printerr("The collided area is not a hitbox")
#
## Utility functions
#func sleep(seconds: float) -> void:
	#await get_tree().create_timer(seconds).timeout
#
#func get_direction():
	#return direction
#
#func int_to_dir(int_dir: int):
	#return DIRECTIONS.RIGHT if(int_dir == 1) else DIRECTIONS.LEFT
#
#func set_direction(dir: DIRECTIONS):
	#if (direction == dir):
		#return
	#direction = dir
	#transform.x = Vector2(dir * abs(scale.x), 0.0)
#
#func turn_around() -> void:
	#if(direction == DIRECTIONS.LEFT):
		#set_direction(DIRECTIONS.RIGHT)
	#else:
		#set_direction(DIRECTIONS.LEFT)
#
#func set_direction_to(obj_pos: Vector2):
	#if(global_position.direction_to(obj_pos).x > 0):
		#set_direction(DIRECTIONS.RIGHT)
	#else:
		#set_direction(DIRECTIONS.LEFT)
#
#func enable_gravity(delta: float) -> void:
	#if(!is_on_floor()):
		#velocity.y += get_gravity().y * delta
#
## dir should be 1 (look right) or -1 (look left)
## func turn_to(dir: int) -> void:
	## REMEMBER TO ALWAYS FLIP LIKE THIS INSTEAD OF USING SCALE, FOR SOME REASON THIS IS CONSISTENT
	## transform.x = Vector2(dir, 0.0)
#
#func apply_gravity(delta: float) -> void:
	#if(not is_on_floor()):
		#velocity.y += get_gravity().y * delta
