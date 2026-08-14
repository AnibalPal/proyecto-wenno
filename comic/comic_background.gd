extends Sprite2D
class_name ComicBackgroundEffect

signal s_background_effect_done

const BackgroundEffects = ComicBackgroundEffectData.BackgroundEffects

func play_background_effect(background_effect: BackgroundEffects, new_image: Texture2D) -> void:
	match background_effect:
		BackgroundEffects.CHANGE:
			texture = new_image
			s_background_effect_done.emit()
		_:
			print("NON EXISTENT EFFECT")
		
