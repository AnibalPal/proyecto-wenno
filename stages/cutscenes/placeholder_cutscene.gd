extends Chamber
class_name CutsceneChamber

@export var content := ""
@export var next_scene_path := ""

@onready var text_label: Label = $Text

func _ready() -> void:
	if(content):
		text_label.text = content

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("attack") or Input.is_action_just_pressed("jump")):
		if(next_scene_path):
			get_tree().change_scene_to_file(next_scene_path)
