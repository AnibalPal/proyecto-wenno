extends CanvasLayer
class_name ComicTransitionEffects

signal s_transition_finished(start_transition : bool)

const Transitions = ComicTransitionEffectData.Transitions

var start_transition := false

func _ready() -> void:
	GlobalTransitionEffects.s_transition_finished.connect(on_transition_finished)

func on_transition_finished(_effect_name : String) -> void:
	s_transition_finished.emit(start_transition)

func play_transition_effect(transition_data : ComicTransitionEffectData, is_start := false) -> void:
	var transition = transition_data.transition_effect
	start_transition = is_start
	match transition:
		Transitions.NONE:
			s_transition_finished.emit(start_transition)
		Transitions.FADE_IN:
			GlobalTransitionEffects.fade_in(transition_data.transition_params["duration"])
		Transitions.FADE_OUT:
			GlobalTransitionEffects.fade_out(transition_data.transition_params["duration"])
		_:
			print("NON EXISTENT TRANSITION " +  str(transition))
