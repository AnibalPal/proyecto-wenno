extends CutsceneState

var target_position_y = null

func enter(_data := {}) -> void:
	if(_data.has("y")):
		target_position_y = _data["y"]
	cutscene_entity.cutscene_animations.play("jump")
	cutscene_entity.velocity = Vector2(0, -cutscene_entity.jump_impulse)

func state_physics_process(_delta: float) -> void:
	if(Helpers.is_equal_custom(cutscene_entity.global_position.y, target_position_y, 5)):
		end_move()
	cutscene_entity.move_and_slide()

func reset_vars() -> void:
	target_position_y = null
