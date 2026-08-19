extends CanvasLayer
class_name CutsceneSkipMenu

signal s_cutscene_skipped

@onready var no_button: Button = $Options/MainContainer/OptionsContainer/No

# aux var to make pause menu not unpause instantly
var first_press = true

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("cutscene_skip")):
		unpause()

func unpause() -> void:
	if(first_press):
		first_press = false
		no_button.grab_focus()
		return
	hide()
	first_press = true
	get_tree().paused = false

func _on_yes_button_down() -> void:
	unpause()
	s_cutscene_skipped.emit()

func _on_no_button_down() -> void:
	unpause()
