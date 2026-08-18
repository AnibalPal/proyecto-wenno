extends CanvasLayer
class_name ComicTransitionEffects

signal s_transition_finished(start_transition : bool)

const Transitions = ComicTransitionEffectData.Transitions

@onready var black_screen: ColorRect = $BlackScreen

var start_transition := false

func play_transition_effect(transition_data : ComicTransitionEffectData, is_start := false) -> void:
	var transition = transition_data.transition_effect
	start_transition = is_start
	match transition:
		Transitions.NONE:
			s_transition_finished.emit(start_transition)
		Transitions.FADE_IN:
			fade_in_effect(transition_data.transition_params["duration"])
		Transitions.FADE_OUT:
			fade_out_effect(transition_data.transition_params["duration"])
		_:
			print("NON EXISTENT TRANSITION " +  str(transition))

func fade_in_effect(duration := 1.0) -> void:
	var fade_in_tween = get_tree().create_tween()
	black_screen.modulate = Color(Color.BLACK, 0.0)
	fade_in_tween.tween_property(black_screen, "modulate:a", 1.0, duration)
	fade_in_tween.finished.connect(on_tween_finished)

func fade_out_effect(duration := 1.0) -> void:
	var fade_out_tween = get_tree().create_tween()
	black_screen.modulate = Color(Color.BLACK, 1.0)
	fade_out_tween.tween_property(black_screen, "modulate:a", 0.0, duration)
	fade_out_tween.finished.connect(on_tween_finished)
	
func on_tween_finished() -> void:
	s_transition_finished.emit(start_transition)
