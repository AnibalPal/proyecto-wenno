@tool
class_name PrototypeEnemyBear 
extends CharacterEntity

# Create a state machine with all states in variables instead of the usual state machine pattern
# if the entity is small, a rule of thumb would be to use the big state machine pattern on bosses
# and use the simple state machine pattern for common enemies. For this simple enemy I will put
# all needed code here, then maybe refactor it depending on the needs of the project

@export var health := 1
@export var stamina := 10
@export var speed := 50
@export var chase_speed := 75
@export var attack3_speed := 150
@export var gravity := 300 
@export var distance_to_stop := 50
@export var distance_to_attack3 := 100
@export var counter_hit_state := false

@onready var hitbox: EnemyHitbox = $ShouldRotate/EnemyHitbox
@onready var hitbox2: EnemyHitbox = $ShouldRotate/EnemyHitbox2
@onready var hitbox3: EnemyHitbox = $ShouldRotate/EnemyHitbox3
@onready var hitbox3end: EnemyHitbox = $ShouldRotate/EnemyHitbox3end
@onready var hurtbox: EnemyHurtbox = $ShouldRotate/EnemyHurtbox
@onready var wall_detection: RayCast2D = $ShouldRotate/WallDetection
@onready var floor_detection: RayCast2D = $ShouldRotate/FloorDetection
@onready var sprite_animations: AnimatedSprite2D = $ShouldRotate/SpriteAnimations
@onready var attack_detection_collision: CollisionShape2D = $ShouldRotate/AttackDetection/CollisionShape2D
@onready var player_detection_collision: CollisionPolygon2D = $ShouldRotate/PlayerDetection/CollisionPolygon2D
@onready var player_awareness_collision: CollisionShape2D = $ShouldRotate/PlayerAwareness/CollisionShape2D
@onready var on_damaged_vfx: AnimationPlayer = $VFXs/OnDamagedVFX

@onready var health_bar: ProgressBar = $UI/HealthBar
@onready var stamina_bar: ProgressBar = $UI/StaminaBar

@onready var attack_cooldown : Timer = $Timers/AttackCooldown

@onready var stunned_duration: Timer = $Timers/StunnedDuration
var stunned_slowdown_rate := 0.9
var counter_pushback_rate := 10

@onready var recoil_duration: Timer = $Timers/RecoilDuration
var clash_slowdown_rate := 0.95
var clash_pushback_rate := 10

@onready var attack_3_duration: Timer = $Timers/Attack3Duration

@onready var timers: Node = $Timers

var chase_target : Player = null

enum States {
	PASSIVE,
	CHASE,
	ATTACK1,
	ATTACK2,
	ATTACK3,
	ATTACK3END,
	STUNNED,
	DEATH,
	RECOIL
}

var current_state := States.PASSIVE
var current_stamina := stamina

func character_ready() -> void:
	if(!Engine.is_editor_hint()):
		# PATCH: Add this line to allow copy pasting without repeating the effect when an enemy is hit
		sprite_animations.material = sprite_animations.material.duplicate(true)
		stamina_bar.value = current_stamina
		health_bar.value = health
		sprite_animations.play("walk")

func _physics_process(_delta: float) -> void:
	if(Engine.is_editor_hint()):
		pass
	else:
		velocity.y += gravity * _delta
		handle_state_process()
		move_and_slide()

func disable_hitboxes() -> void:
	hitbox.disable()
	hitbox2.disable()
	hitbox3.disable()
	hitbox3end.disable()

func update_current_stamina(value:int) -> void:
	current_stamina = value
	stamina_bar.value = current_stamina

func update_current_health(value: int) -> void:
	health = value
	health_bar.value = value

func stop_timers() -> void:
	for timer in timers.get_children():
		timer.stop()

func turn_towards(objective_position: Vector2) -> void:
	var move_direction := global_position.direction_to(objective_position)
	if(move_direction.x < 0):
		turn_left()
	else:
		turn_right()

func handle_state_process() -> void:
	match current_state:
		States.PASSIVE:
			if(facing_right):
				velocity.x = speed
			else:
				velocity.x = -speed
			if(wall_detection.is_colliding()):
				turn_around()
			if(is_on_floor() and !floor_detection.is_colliding()):
				turn_around()
		States.CHASE:
			if(chase_target):
				if(Helpers.is_wall_between(global_position, chase_target.global_position)):
					handle_transition(States.PASSIVE)
					return
				turn_towards(chase_target.global_position)
				move_forward(chase_speed)
				if(abs(global_position.x - chase_target.global_position.x) < distance_to_stop):
					velocity.x = 0.0
					sprite_animations.play("idle")
				else:
					sprite_animations.play("run")
		States.ATTACK1:
			pass
		States.ATTACK2:
			pass
		States.ATTACK3:
			pass
		States.ATTACK3END:
			pass
		States.STUNNED:
			velocity.x *= stunned_slowdown_rate
		States.DEATH:
			velocity.x = 0.0
			pass
		States.RECOIL:
			velocity.x *= clash_slowdown_rate
			if(is_equal_approx(velocity.x, 0)):
				handle_transition(States.CHASE)
			pass
		_:
			pass
		

func handle_transition(new_state : States) -> void:
	if(health <= 0 or new_state == States.DEATH):
		disable_hitboxes()
		hurtbox.disable()
		attack_detection_collision.set_deferred("disabled", true)
		stunned_duration.stop()
		sprite_animations.play("death")
		current_state = States.DEATH
		return
	if(new_state == States.PASSIVE):
		counter_hit_state = false
		attack_detection_collision.set_deferred("disabled", true)
		player_awareness_collision.set_deferred("disabled", true)
		player_detection_collision.set_deferred("disabled", false)
		chase_target = null
		sprite_animations.play("walk")
	if(new_state == States.ATTACK1):
		if(chase_target):
			turn_towards(chase_target.global_position)
		attack_detection_collision.set_deferred("disabled", true)
		velocity = Vector2.ZERO
		counter_hit_state = true
		sprite_animations.play("attack1")
	if(new_state == States.ATTACK2):
		if(chase_target):
			turn_towards(chase_target.global_position)
		attack_detection_collision.set_deferred("disabled", true)
		velocity = Vector2.ZERO
		counter_hit_state = true
		sprite_animations.play("attack2")
	if(new_state == States.ATTACK3):
		attack_3_duration.start()
		if(chase_target):
			turn_towards(chase_target.global_position)
		hitbox3.enable()
		attack_detection_collision.set_deferred("disabled", true)
		move_forward(attack3_speed)
		counter_hit_state = true
		sprite_animations.play("attack3")
	if(new_state == States.ATTACK3END):
		hitbox3.disable()
		hitbox3end.enable()
		attack_detection_collision.set_deferred("disabled", true)
		velocity = Vector2.ZERO
		counter_hit_state = true
		sprite_animations.play("attack3finisher")
	if(new_state == States.CHASE):
		player_detection_collision.set_deferred("disabled", true)
		player_awareness_collision.set_deferred("disabled", false)
		disable_hitboxes()
		attack_cooldown.start()
		counter_hit_state = false
		sprite_animations.play("run")
	if(new_state == States.STUNNED):
		GlobalVFXs.hitstop()
		move_backwards(float(speed) * counter_pushback_rate)
		stop_timers()
		stunned_duration.start()
		disable_hitboxes()
		attack_detection_collision.set_deferred("disabled", true)
		player_detection_collision.set_deferred("disabled", true)
		counter_hit_state = false
		sprite_animations.play("stunned")
	if(new_state == States.RECOIL):
		recoil_duration.start()
		disable_hitboxes()
		attack_detection_collision.set_deferred("disabled", true)
		counter_hit_state = false
		sprite_animations.play("recoil")
	current_state = new_state

func on_damaged(damage, attacker_position) -> void:
	on_damaged_vfx.play("on_damaged_effect")
	if(counter_hit_state):
		attack_3_duration.stop()
		GlobalVFXs.hitstop()
		var direction = global_position.direction_to(attacker_position)
		if(direction.x > 0): 
			turn_right()
		else:
			turn_left()
		move_backwards(float(speed) * counter_pushback_rate)
		update_current_health(health - damage * 2)
		# Should be a different value but do it using the damage var for now
		update_current_stamina(current_stamina - damage * 3)
		if(current_stamina <= 0 and current_state != States.STUNNED):
			handle_transition(States.STUNNED)
		else:
			handle_transition(States.RECOIL)
	else:
		update_current_health(health - damage)
		# Should be a different value but do it using the damage var for now
		update_current_stamina(current_stamina - damage * 2)
		var direction = global_position.direction_to(attacker_position)
		if(direction.x > 0): 
			turn_right()
		else:
			turn_left()
		if(current_stamina <= 0 and current_state != States.STUNNED):
			handle_transition(States.STUNNED)
	if(health <= 0):
		handle_transition(States.DEATH)

func on_hit() -> void:
	pass

func on_clash(other_position: Vector2) -> void:
	stop_timers()
	# Should be another value but I am not sure if this will be implemented
	var direction = global_position.direction_to(other_position)
	if(direction.x > 0): 
		turn_right()
	else:
		turn_left()
	update_current_stamina(current_stamina - 1)
	move_backwards(float(speed) * clash_pushback_rate)
	if(current_stamina <= 0):
		handle_transition(States.STUNNED)
	else:
		handle_transition(States.RECOIL)

func _on_player_detection_area_entered(area: Area2D) -> void:
	if(Helpers.is_wall_between(global_position, area.global_position)):
		return
	chase_target = area.owner
	handle_transition(States.CHASE)

func _on_player_awareness_area_exited(_area: Area2D) -> void:
	handle_transition(States.PASSIVE)

func _on_attack_detection_area_entered(_area: Area2D) -> void:
	if(Helpers.is_wall_between(global_position, _area.global_position)):
		return
	if(chase_target):
		var distance_to_target := global_position.distance_to(chase_target.global_position)
		if(distance_to_target > distance_to_attack3):
			handle_transition(States.ATTACK3)
		else:
			handle_transition(States.ATTACK1)

func _on_sprite_animations_frame_changed() -> void:
	if(!Engine.is_editor_hint()):
		if(sprite_animations.animation == "attack1"):
			if(sprite_animations.frame == 2):
				hitbox.enable()
			else:
				hitbox.disable()
		if(sprite_animations.animation == "attack2"):
			if(sprite_animations.frame == 2):
				hitbox2.enable()
			else:
				hitbox2.disable()

func _on_sprite_animations_animation_finished() -> void:
	if(!Engine.is_editor_hint()):
		if(sprite_animations.animation == "death"):
			queue_free()
		if(sprite_animations.animation == "attack1"):
			if(chase_target):
				var distance_to_target := global_position.distance_to(chase_target.global_position)
				if(distance_to_target > distance_to_attack3):
					handle_transition(States.ATTACK3)
				else:
					handle_transition(States.ATTACK2)
			else:
				handle_transition(States.ATTACK2)
		if(sprite_animations.animation == "attack2" and sprite_animations.frame > 0):
			handle_transition(States.CHASE)
		if(sprite_animations.animation == "attack3finisher" and sprite_animations.frame > 0):
			handle_transition(States.CHASE)

func _on_enemy_hurtbox_area_entered(_area: Area2D) -> void:
	# NOTE: THIS IS A PATCH, the proper solution is to change the combat manager to get the entities
	# in contact instead of just the position
	chase_target = _area.owner

func _on_stunned_duration_timeout() -> void:
	if(!Engine.is_editor_hint()):
		if(current_state == States.STUNNED):
			update_current_stamina(stamina)
			handle_transition(States.CHASE)

func _on_recoil_duration_timeout() -> void:
	if(!Engine.is_editor_hint()):
		if(current_state == States.RECOIL):
			handle_transition(States.CHASE)

func _on_attack_cooldown_timeout() -> void:
	attack_detection_collision.set_deferred("disabled", false)

func _on_attack_3_duration_timeout() -> void:
	handle_transition(States.ATTACK3END)
