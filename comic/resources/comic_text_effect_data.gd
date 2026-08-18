@tool
extends ComicEffectData
class_name ComicTextEffectData

enum TextEffects {
	NONE,
	TYPING,
	FADE_IN
}

@export var text := ""
@export var text_effect := TextEffects.NONE:
	set(value):
		match value:
			TextEffects.TYPING:
				text_effect_params = {
					"typing_speed" : 20.0
				}
			_:
				text_effect_params = {}
		text_effect = value

@export var text_effect_params := {}
