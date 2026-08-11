extends Resource
class_name ComicStep

enum Transitions {
	NONE, # a cut
	FADE_IN,
	FADE_OUT,
}

@export var start_transition := Transitions.NONE
@export var end_transition := Transitions.NONE
@export var transition_params := {}
@export var background_image:CompressedTexture2D
@export var text := ""
