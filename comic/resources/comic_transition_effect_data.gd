@tool
@icon("res://assets/icons/built_in/ArrowRight.svg")
extends ComicEffectData
class_name ComicTransitionEffectData

enum Transitions {
	NONE, # a cut
	FADE_IN,
	FADE_OUT,
}

@export var transition_effect := Transitions.NONE:
	set(value):
		match(value):
			Transitions.FADE_IN, Transitions.FADE_OUT:
				transition_params = {
					"duration": 1.0
				}
			_:
				transition_params = {}
		transition_effect = value

@export var transition_params := {}
