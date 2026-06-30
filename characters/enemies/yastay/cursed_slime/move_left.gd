extends CutsceneState

func enter(_data := {}) -> void:
	#cutscene_entity.cutscene_animations
	pass

func cutscene_state_process(_delta) -> void:
	# DO NOT USE move_and_slide
	pass

func cutscene_state_physics_process(_delta) -> void:
	# DO NOT USE move_and_slide
	# use end_move() somewhere here
	pass

func reset_vars() -> void:
	# Reset all variables from this state
	pass
