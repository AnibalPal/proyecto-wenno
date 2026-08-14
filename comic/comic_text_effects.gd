extends CanvasLayer
class_name ComicTextEffects

signal s_text_effect_finished

const TextEffects := ComicTextEffectData.TextEffects

@onready var image_text: Label = $ImageText

var typing_duration := 1

func set_text(new_text: String) -> void:
	image_text.show()
	image_text.visible_characters = 0
	image_text.text = new_text

func play_text_effect(text_effect_data: ComicTextEffectData) -> void:
	if(text_effect_data.text):
		set_text(text_effect_data.text)
		match text_effect_data.text_effect:
			TextEffects.TYPING:
				var play_text_tween = get_tree().create_tween()
				play_text_tween.tween_property(image_text, "visible_characters", len(image_text.text), typing_duration)
				play_text_tween.finished.connect(on_text_effect_tween_finished)
			TextEffects.FADE_IN:
				pass
			_:
				print("NON EXISTENT TEXT EFFECT " + str(text_effect_data.text_effect))
	else:
		print("NO TEXT")

func on_text_effect_tween_finished() -> void:
	s_text_effect_finished.emit()
