extends Control
class_name Comic

@export var comic_data : Array[ComicStep] = []
@export var text_speed := 1
@export_file("*.tscn") var comic_end_path := ""


@onready var comic_transition_effects: CanvasLayer = $ComicTransitionEffects
@onready var comic_camera: ComicCamera = $ComicCamera
@onready var background_image: Sprite2D = $Background
@onready var image_text: Label = $TextLayer/ImageText

var comic_idx := 0
var transition_effect_playing := false
var camera_effect_playing := false
var text_playing := false
var comic_done := false
var visible_text_characters := 0.0

func _ready() -> void:
	assert(len(comic_data) > 0, "COMIC HAS NO DATA")
	comic_transition_effects.s_transition_finished.connect(on_transition_finished)
	comic_camera.s_camera_effect_done.connect(on_camera_effect_finished)
	start_comic_step()
	play_start_transition()
	play_camera_effect()

func on_transition_finished(start_transition := false) -> void:
	transition_effect_playing = false
	if(start_transition):
		var current_step_data = comic_data[comic_idx]
		if(current_step_data.text):
			start_text_play()
	else:
		comic_idx += 1
		if(comic_idx >= len(comic_data)):
			end()
		else:
			start_comic_step()
			play_start_transition()
			play_camera_effect()


func on_camera_effect_finished() -> void:
	camera_effect_playing = false

func _process(_delta: float) -> void:
	if(not comic_done):
		if(Input.is_action_just_pressed("cutscene_next") and not transition_effect_playing and not camera_effect_playing):
			next()
			
		if(text_playing):
			if(visible_text_characters < len(image_text.text)):
				visible_text_characters += _delta * text_speed
				image_text.visible_characters = int(visible_text_characters)
			else:
				text_playing = false

func next() -> void:
	if(text_playing):
		text_playing = false
		image_text.visible_characters = len(image_text.text)
	else:
		play_end_transition()

func start_comic_step() -> void:
	var current_step_data = comic_data[comic_idx]
	
	# Reset text variables
	if(current_step_data.text):
		image_text.hide()
		text_playing = false
		visible_text_characters = 0.0
		image_text.visible_characters = 0
		image_text.text = current_step_data.text
	
	# Set background
	if(current_step_data.background_image):
		background_image.texture = current_step_data.background_image

func play_start_transition() -> void:
	transition_effect_playing = true
	var current_step_data = comic_data[comic_idx]
	comic_transition_effects.play_transition_effect(current_step_data.start_transition, true)

func start_text_play() -> void:
	text_playing = true
	#TODO: add animation for text showing up
	image_text.show()

func play_end_transition() -> void:
	transition_effect_playing = true
	var current_step_data = comic_data[comic_idx]
	comic_transition_effects.play_transition_effect(current_step_data.end_transition, false)

func play_camera_effect() -> void:
	camera_effect_playing = true
	var current_step_data = comic_data[comic_idx]
	comic_camera.play_camera_effect(current_step_data.camera_effect, current_step_data.camera_effect_params)

func end() -> void:
	comic_done = true
	get_tree().change_scene_to_file(comic_end_path)
