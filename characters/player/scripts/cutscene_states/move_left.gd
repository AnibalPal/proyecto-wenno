extends CutsceneState

var move_duration_msecs = null 
var target_position_x = null

func cutscene_state_enter(_data := {}) -> void:
	if(_data.has("x")):
		target_position_x = _data["x"]
	cutscene_entity.turn_left()
	cutscene_entity.move_forward(cutscene_entity.speed)
	if(cutscene_entity.is_on_floor()):
		cutscene_entity.entity_animations.play("run")

func state_physics_process(_delta: float) -> void:
	if(cutscene_entity.is_on_floor()):
		cutscene_entity.entity_animations.play("run")
	else:
		cutscene_entity.enable_gravity(_delta)
		cutscene_entity.entity_animations.play("fall")
	if(Helpers.is_equal_custom(cutscene_entity.global_position.x, target_position_x, 10)):
		end_move()

func reset_vars() -> void:
	target_position_x = null
