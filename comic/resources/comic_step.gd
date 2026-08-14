extends Resource
class_name ComicStep

# Must hold a list of effects and the logic to tell when they are all completed

@export var start_transition : ComicTransitionEffectData
@export var comic_effects : Array[ComicEffectData]
@export var end_transition : ComicTransitionEffectData
