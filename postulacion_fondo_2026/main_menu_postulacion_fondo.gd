extends CanvasLayer

@onready var start_game_button: Button = $MainMenuPostulacionFondo/StartGameButton

func _ready() -> void:
	start_game_button.grab_focus()

func _on_start_game_button_button_down() -> void:
	GlobalTransitionEffects.fade_in()
	layer = 0
	get_tree().change_scene_to_file("res://postulacion_fondo_2026/intro_comic_postulacion_fondo.tscn")


func _on_salir_button_down() -> void:
	get_tree().quit()
