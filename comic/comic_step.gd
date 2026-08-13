extends Resource
class_name ComicStep

enum Transitions {
	NONE, # a cut
	FADE_IN,
	FADE_OUT,
}

enum CameraEffects {
	NONE,
	SET_POSITION,
	PANNING,
	ZOOM
}

enum TextEffects {
	NONE,
	TYPING,
	FADE_IN
}

@export var start_transition := Transitions.NONE
@export var end_transition := Transitions.NONE
@export var transition_params := {}

@export var text_effect := TextEffects.NONE
@export var text_effect_params := {}

@export var camera_effect := CameraEffects.NONE
@export var camera_effect_params := {}

@export var background_image:CompressedTexture2D
@export var text := ""
