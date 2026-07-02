extends CutsceneState

func enter(_data := {}) -> void:
	if(cutscene_entity.velocity.y <= 0):
		cutscene_entity.velocity.y = 0
	cutscene_entity.entity_animations.play("fall")

func state_physics_process(_delta) -> void:
	cutscene_entity.enable_gravity(_delta)
	if(cutscene_entity.is_on_floor()):
		end_move()
	cutscene_entity.move_and_slide()
