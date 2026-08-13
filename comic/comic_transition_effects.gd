extends CanvasLayer
class_name ComicTransitionEffects

signal s_transition_finished(start_transition : bool)

const Transitions = ComicStep.Transitions

@onready var transition_effects_player: AnimationPlayer = $TransitionEffectsPlayer

var start_transition := false

func play_transition_effect(transition : Transitions, is_start := false) -> void:
	start_transition = is_start
	match transition:
		Transitions.NONE:
			s_transition_finished.emit(start_transition)
		Transitions.FADE_IN:
			transition_effects_player.play("fade_in")
		Transitions.FADE_OUT:
			transition_effects_player.play("fade_out")
		_:
			print("NON EXISTENT TRANSITION " +  str(transition))

func _on_transition_effects_player_animation_finished(_anim_name: StringName) -> void:
	s_transition_finished.emit(start_transition)
