extends CutsceneState

var move_duration_msecs = null 
var target_position_x = null

func cutscene_state_enter(_data := {}) -> void:
	if(_data.has("x")):
		target_position_x = _data["x"]
	cutscene_entity.turn_right()
	cutscene_entity.move_forward(cutscene_entity.speed)
	if(cutscene_entity.is_on_floor()):
		cutscene_entity.cutscene_animations.play("run")

func cutscene_state_physics_process() -> void:
	if(cutscene_entity.is_on_floor()):
		cutscene_entity.cutscene_animations.play("run")
	else:
		cutscene_entity.cutscene_animations.play("fall")
	if(Helpers.is_equal_custom(cutscene_entity.global_position.x, target_position_x, 10)):
		cutscene_state_manager.s_step_finished.emit()
		cutscene_state_manager.cutscene_transition_to(cutscene_state_manager.IDLE)
