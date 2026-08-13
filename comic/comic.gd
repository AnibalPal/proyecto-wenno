extends Control
class_name Comic

@export var comic_data : Array[ComicStep] = []
@export_file("*.tscn") var comic_end_path := ""

@onready var comic_transition_effects: CanvasLayer = $ComicTransitionEffects
@onready var comic_camera: ComicCamera = $ComicCamera
@onready var background_image: Sprite2D = $Background

@onready var comic_text_layer: ComicTextEffects = $ComicTextLayer

var comic_idx := 0
var transition_effect_playing := false
var camera_effect_playing := false
var text_playing := false
var comic_done := false

func _ready() -> void:
	assert(len(comic_data) > 0, "COMIC HAS NO DATA")
	setup_signals()
	start_comic_step()

func setup_signals() -> void:
	comic_transition_effects.s_transition_finished.connect(on_transition_finished)
	comic_camera.s_camera_effect_done.connect(on_camera_effect_finished)
	comic_text_layer.s_text_effect_finished.connect(on_text_effect_finished)

func on_text_effect_finished() -> void:
	text_playing = false

func on_transition_finished(start_transition := false) -> void:
	transition_effect_playing = false
	if(start_transition):
		# Place what I want to happen here after the start transition if needed, for example move text
		pass
	else:
		comic_idx += 1
		if(comic_idx >= len(comic_data)):
			end()
		else:
			start_comic_step()


func on_camera_effect_finished() -> void:
	camera_effect_playing = false

func _process(_delta: float) -> void:
	if(not comic_done):
		if(Input.is_action_just_pressed("cutscene_next") and not are_effects_playing()):
			next()

func are_effects_playing() -> bool:
	return text_playing or transition_effect_playing or camera_effect_playing

func next() -> void:
	end_comic_step()

func start_comic_step() -> void:
	var current_step_data = comic_data[comic_idx]
	
	# Set background
	if(current_step_data.background_image):
		background_image.texture = current_step_data.background_image
	
	play_start_transition()
	play_camera_effect()
	play_text_effect()

func end_comic_step() -> void:
	play_end_transition()

func play_start_transition() -> void:
	transition_effect_playing = true
	var current_step_data = comic_data[comic_idx]
	comic_transition_effects.play_transition_effect(current_step_data.start_transition, true)

func play_end_transition() -> void:
	transition_effect_playing = true
	var current_step_data = comic_data[comic_idx]
	comic_transition_effects.play_transition_effect(current_step_data.end_transition, false)

func play_text_effect() -> void:
	text_playing = true
	var current_step_data = comic_data[comic_idx]
	comic_text_layer.set_text(current_step_data.text)
	comic_text_layer.play_text_effect(current_step_data.text_effect)

func play_camera_effect() -> void:
	camera_effect_playing = true
	var current_step_data = comic_data[comic_idx]
	comic_camera.play_camera_effect(current_step_data.camera_effect, current_step_data.camera_effect_params)

func end() -> void:
	comic_done = true
	get_tree().change_scene_to_file(comic_end_path)
