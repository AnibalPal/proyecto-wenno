extends CanvasLayer

signal s_transition_finished(effect_name : String)

@onready var black_screen: ColorRect = $BlackScreen

func fade_in(duration := 1.0) -> void:
	var fade_in_tween = get_tree().create_tween()
	black_screen.modulate = Color(Color.BLACK, 0.0)
	fade_in_tween.tween_property(black_screen, "modulate:a", 1.0, duration)
	fade_in_tween.finished.connect(on_tween_finished.bind("fade_in"))

func fade_out(duration := 1.0) -> void:
	var fade_out_tween = get_tree().create_tween()
	black_screen.modulate = Color(Color.BLACK, 1.0)
	fade_out_tween.tween_property(black_screen, "modulate:a", 0.0, duration)
	fade_out_tween.finished.connect(on_tween_finished.bind("fade_out"))

func on_tween_finished(effect_name: String) -> void:
	s_transition_finished.emit(effect_name)
