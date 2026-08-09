extends Resource
class_name ComicStep

enum Transitions {
	NONE, # a cut
	FADE_IN,
	FADE_OUT,
}

@export var background_image:CompressedTexture2D
@export var text := ""
@export var transition := Transitions.NONE
