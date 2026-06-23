extends CutsceneState

func cutscene_state_enter(_data := {}) -> void:
	cutscene_entity.velocity = Vector2.ZERO
	if(cutscene_entity.is_on_floor()):
		cutscene_entity.cutscene_animations.play("idle")
	else:
		cutscene_entity.cutscene_animations.play("fall")	

func cutscene_state_physics_process() -> void:
	if(cutscene_entity.is_on_floor()):
		cutscene_entity.cutscene_animations.play("idle")
