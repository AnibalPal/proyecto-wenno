extends ComicEffectData
class_name ComicCameraEffectData

enum CameraEffects {
	SET_POSITION,
	PANNING,
	CENTER,
	ZOOM,
}

@export var camera_effect := CameraEffects.SET_POSITION
@export var camera_effect_params := {}
