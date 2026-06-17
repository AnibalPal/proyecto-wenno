@tool
class_name CutsceneEntityBase
extends CharacterEntity

signal s_action_complete

@export var speed := 200

# Vector2 or null
var target_x_position : Variant = null

func _physics_process(_delta: float) -> void:
	if(!Engine.is_editor_hint()):
		if(target_x_position):
			if(Helpers.is_equal_custom(global_position.x, target_x_position, 5)):
				velocity.x = 0
				target_x_position = null
				s_action_complete.emit()
		move_and_slide()

func handle_action(action: Enums.CutsceneActions, data := {}):
	match action:
		Enums.CutsceneActions.HIDE:
			process_mode = Node.PROCESS_MODE_DISABLED
			hide()
			s_action_complete.emit()
		Enums.CutsceneActions.SHOW:
			process_mode = Node.PROCESS_MODE_INHERIT
			show()
			s_action_complete.emit()
		Enums.CutsceneActions.MOVE:
			if(data.has("x")):
				target_x_position = data["x"]
				var dir = global_position.direction_to(Vector2(data["x"], global_position.y))
				if(dir.x > 0):
					turn_right()
				else:
					turn_left()
				move_forward(speed)
		Enums.CutsceneActions.TALK:
			print("TALK PENDING IMPLEMENTATION")
			s_action_complete.emit()
		Enums.CutsceneActions.ANIMATION:
			print("ANIMATION PENDING IMPLEMENTATION")
			s_action_complete.emit()		
		Enums.CutsceneActions.WAIT:
			print("WAIT PENDING IMPLEMENTATION")
			s_action_complete.emit()					
	pass
