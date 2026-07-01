extends CutsceneState

func enter(_data := {}) -> void:
	cutscene_entity.velocity.x = 0
	cutscene_entity.sprite_animations.play("idle")

func cutscene_state_physics_process(_delta: float) -> void:
	cutscene_entity.enable_gravity(_delta)
	if(cutscene_entity.is_on_floor()):
		cutscene_entity.sprite_animations.play("idle")
