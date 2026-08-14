extends ComicEffectData
class_name ComicTextEffectData

enum TextEffects {
	TYPING,
	FADE_IN
}

@export var text := ""
@export var text_effect := TextEffects.TYPING
@export var text_effect_params := {}
