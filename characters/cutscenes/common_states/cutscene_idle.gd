extends CutsceneState

func cutscene_state_enter(_data := {}) -> void:
	cutscene_entity.velocity.x = 0
	if(cutscene_entity.entity_animations):
		if(cutscene_entity.is_on_floor()):
			cutscene_entity.entity_animations.play("idle")
		else:
			cutscene_entity.entity_animations.play("fall")	
	else:
		printerr("No entity_animations present in the following node: %s" % owner.name)

func state_physics_process(_delta: float) -> void:
	cutscene_entity.enable_gravity(_delta)
	if(cutscene_entity.is_on_floor()):
		if(cutscene_entity.entity_animations):
			cutscene_entity.entity_animations.play("idle")
	cutscene_entity.move_and_slide()
