extends ComicEffectData
class_name ComicTransitionEffectData

enum Transitions {
	NONE, # a cut
	FADE_IN,
	FADE_OUT,
}

@export var transition_effect := Transitions.NONE
@export var transition_params := {}
