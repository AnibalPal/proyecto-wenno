# TODO: CHANGE THIS SCRIPT TO A CUTSCENE STATE MACHINE PATTERN
@tool
class_name CutsceneEntityBase
extends CharacterEntity

signal s_action_complete

const DIALOGUE_BUBBLE_Y_OFFSET := 10

@export var dialogue_bubble : PackedScene
@export var speed := 200

# TODO: This could be an animatedSprite2D as well depending on the cutscene entity
@onready var cutscene_entity_sprite: Sprite2D = $ShouldRotate/CutsceneEntitySprite

# Vector2 or null
var target_x_position : Variant = null

func character_ready() -> void:
	assert(dialogue_bubble, "%s error: no dialogue bubble set" % name)

func _physics_process(_delta: float) -> void:
	if(!Engine.is_editor_hint()):
		if(target_x_position):
			if(Helpers.is_equal_custom(global_position.x, target_x_position, 5)):
				velocity.x = 0
				target_x_position = null
				s_action_complete.emit()
		move_and_slide()

func handle_action(action: Enums.CutsceneCommonActions, data := {}):
	match action:
		Enums.CutsceneCommonActions.HIDE:
			# NOTE: this has a bug with the physics_process on the entity that calls it
			# I am not using it currently because I queue_free the cutscene when completed
			hide()
			s_action_complete.emit()
			process_mode = Node.PROCESS_MODE_DISABLED
		Enums.CutsceneCommonActions.SHOW:
			process_mode = Node.PROCESS_MODE_INHERIT
			show()
			s_action_complete.emit()
		Enums.CutsceneCommonActions.MOVE:
			if(data.has("x")):
				target_x_position = data["x"]
				var dir = global_position.direction_to(Vector2(data["x"], global_position.y))
				if(dir.x > 0):
					turn_right()
				else:
					turn_left()
				move_forward(speed)
		Enums.CutsceneCommonActions.TALK:
			if(data.has("width")):
				instantiate_dialogue_bubble(data["text"], data["width"])			
			else:
				instantiate_dialogue_bubble(data["text"])
		Enums.CutsceneCommonActions.ANIMATION:
			print("ANIMATION PENDING IMPLEMENTATION")
			s_action_complete.emit()		
		Enums.CutsceneCommonActions.WAIT:
			print("WAIT PENDING IMPLEMENTATION")
			s_action_complete.emit()					

func instantiate_dialogue_bubble(text:= "", width := 240):
	var dialogue_bubble_instance : DialogueBubble = dialogue_bubble.instantiate()
	dialogue_bubble_instance.dialogue_text = text
	dialogue_bubble_instance.minimum_bubble_width = width
	var cutscene_entity_y_offset := (cutscene_entity_sprite.texture.get_size().y * cutscene_entity_sprite.scale.y) + DIALOGUE_BUBBLE_Y_OFFSET
	dialogue_bubble_instance.global_position = Vector2(global_position.x, global_position.y - cutscene_entity_y_offset)
	dialogue_bubble_instance.s_dialogue_complete.connect(on_dialogue_complete)
	get_tree().root.add_child(dialogue_bubble_instance)

func on_dialogue_complete() -> void:
	s_action_complete.emit()
