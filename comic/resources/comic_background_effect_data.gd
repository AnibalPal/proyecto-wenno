extends ComicEffectData
class_name ComicBackgroundEffectData

enum BackgroundEffects {
	CHANGE
}

@export var background_effect := BackgroundEffects.CHANGE
@export var new_background_image : Texture2D 
