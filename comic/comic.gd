extends Control

@export var cutscene_data : Array[ComicStep] = []

var cutscene_idx := 0
var text_playing := false

func _ready() -> void:
	pass

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("cutscene_next")):
		next()

func next() -> void:
	pass

func end() -> void:
	pass
