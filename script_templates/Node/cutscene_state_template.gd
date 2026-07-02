extends CutsceneState

func enter(_data := {}) -> void:
	#cutscene_entity.cutscene_animations
	pass

func state_process(_delta) -> void:
	# use end_move() somewhere here or in physics process
	pass

func state_physics_process(_delta) -> void:
	# use end_move() somewhere here or in process
	pass

func reset_vars() -> void:
	# Reset all variables from this state
	pass
