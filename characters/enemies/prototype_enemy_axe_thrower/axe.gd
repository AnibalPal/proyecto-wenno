extends CharacterBody2D

var gravity := 300

func _physics_process(_delta: float) -> void:
	if(is_on_floor() or is_on_ceiling() or is_on_wall()):
		queue_free()
	velocity.y += gravity * _delta
	move_and_slide()

func on_damaged(_damage: int, _other_entity_position: Vector2) -> void:
	pass

func on_hit() -> void:
	queue_free()

func on_clash(_other_collision_position: Vector2) -> void:
	queue_free()
