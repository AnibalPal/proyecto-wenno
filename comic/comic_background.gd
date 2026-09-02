extends Node2D
class_name ComicBackgroundEffect

signal s_background_effect_done

const BackgroundEffects = ComicBackgroundEffectData.BackgroundEffects

@onready var static_background: Sprite2D = $StaticBackground
@onready var animated_background: AnimatedSprite2D = $AnimatedBackground

func play_background_effect(background_effect: BackgroundEffects, new_image: Texture2D) -> void:
	match background_effect:
		BackgroundEffects.CHANGE:
			static_background.show()
			animated_background.hide()
			animated_background.stop()
			static_background.texture = new_image
			s_background_effect_done.emit()
		BackgroundEffects.ANIMATED_CHANGE:
			static_background.hide()
			animated_background.show()
			# TODO: Make this a parameter in the function call
			animated_background.play("default")
			s_background_effect_done.emit()
		_:
			print("NON EXISTENT EFFECT")
		
