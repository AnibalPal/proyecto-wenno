@icon("res://assets/icons/built_in/CameraAttributes.svg")
extends Resource
class_name ComicStep

@export var enabled := true
@export var start_transition : ComicTransitionEffectData
@export var comic_effects : Array[ComicEffectData]
@export var end_transition : ComicTransitionEffectData
