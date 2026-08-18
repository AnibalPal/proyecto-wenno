extends Control
class_name Comic

@export var initial_background : Texture2D
@export var comic_data : Array[ComicStep] = []
@export_file("*.tscn") var comic_end_path := ""

@onready var comic_transition_effects: CanvasLayer = $ComicTransitionEffects
@onready var comic_camera: ComicCameraEffect = $ComicCamera
@onready var background_image: ComicBackgroundEffect = $Background
@onready var comic_text_layer: ComicTextEffects = $ComicTextLayer

var comic_idx := 0
var transition_effect_playing := false
var camera_effect_playing := false
var text_playing := false
var background_effect_playing := false

var expected_effect_amount := 0

func _ready() -> void:
	assert(len(comic_data) > 0, "COMIC HAS NO DATA")
	if(initial_background):
		background_image.texture = initial_background
	setup_signals()
	start_comic_step()

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("cutscene_next")):
		if(comic_text_layer.is_text_playing):
			comic_text_layer.complete_text()
		else:
			if(not are_effects_playing()):
				end_comic_step()

# Signal related functions
func setup_signals() -> void:
	comic_transition_effects.s_transition_finished.connect(on_transition_finished)
	comic_camera.s_camera_effect_done.connect(on_effect_finished)
	comic_text_layer.s_text_effect_finished.connect(on_effect_finished)
	background_image.s_background_effect_done.connect(on_effect_finished)

func on_transition_finished(is_end_transition := false) -> void:
	transition_effect_playing = false
	if(not is_end_transition):
		# Place what I want to happen here after the start transition if needed, for example move text
		play_effects()
	else:
		advance_to_next_step()

func on_effect_finished() -> void:
	expected_effect_amount -= 1
	check_if_show_caret()

func check_if_show_caret() -> void:
	if(not are_effects_playing()):
		comic_text_layer.show_continue_caret()

# Comic move logic related functions
func advance_to_next_step() -> void:
	comic_idx += 1
	if(comic_idx >= len(comic_data)):
		end()
	else:
		start_comic_step()

func are_effects_playing() -> bool:
	return transition_effect_playing or expected_effect_amount > 0

func start_comic_step() -> void:
	var current_step_data = comic_data[comic_idx]
	if(not current_step_data.enabled):
		advance_to_next_step()
	expected_effect_amount = len(current_step_data.comic_effects)
	if(current_step_data.start_transition):
		play_transition_effect(current_step_data.start_transition, false)
	else:
		play_effects()

func end_comic_step() -> void:
	var current_step_data = comic_data[comic_idx]
	if(current_step_data.end_transition):
		play_transition_effect(current_step_data.end_transition, true)
	else:
		advance_to_next_step()
		
func end() -> void:
	get_tree().change_scene_to_file(comic_end_path)

# Effect playing functions
func play_effects() -> void:
	var current_step_effects_data := comic_data[comic_idx].comic_effects
	for effect_data in current_step_effects_data:
		if(effect_data is ComicTextEffectData):
			play_text_effect(effect_data)
		elif(effect_data is ComicBackgroundEffectData):
			play_background_effect(effect_data)
		elif(effect_data is ComicTransitionEffectData):
			play_transition_effect(effect_data)
		elif(effect_data is ComicCameraEffectData):
			play_camera_effect(effect_data)
		else:
			print("UNRECOGNIZED EFFECT")

func play_transition_effect(step_data : ComicTransitionEffectData, is_end_transition := false) -> void:
	transition_effect_playing = true
	comic_transition_effects.play_transition_effect(step_data, is_end_transition)

func play_text_effect(effect_data : ComicTextEffectData) -> void:
	text_playing = true
	comic_text_layer.play_text_effect(effect_data)

func play_camera_effect(effect_data : ComicCameraEffectData) -> void:
	camera_effect_playing = true
	comic_camera.play_camera_effect(effect_data)

func play_background_effect(effect_data : ComicBackgroundEffectData) -> void:
	background_effect_playing = true
	background_image.play_background_effect(effect_data.background_effect, effect_data.new_background_image)
