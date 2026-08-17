extends CanvasLayer
class_name ComicTextEffects

signal s_text_effect_finished

const TextEffects := ComicTextEffectData.TextEffects

@onready var image_text: Label = $ImageText
@onready var next_comic_caret: TextureRect = $ImageText/NextComicCaret
@onready var caret_animation_player: AnimationPlayer = $ImageText/NextComicCaret/CaretAnimationPlayer

var typing_duration := 1

@export var typing_speed := 20.0
var visible_chars := 0.0
var is_text_playing := false

func set_text(new_text: String) -> void:
	image_text.show()
	image_text.visible_characters = 0
	image_text.text = new_text

func _process(delta: float) -> void:
	if(is_text_playing):
		visible_chars += delta * typing_speed
		image_text.visible_characters = int(visible_chars)
		if(image_text.visible_characters >= len(image_text.text)):
			on_typing_effect_finished()

func play_text_effect(text_effect_data: ComicTextEffectData) -> void:
	hide_continue_caret()
	if(text_effect_data.text):
		set_text(text_effect_data.text)
		match text_effect_data.text_effect:
			TextEffects.NONE:
				image_text.visible_characters = -1
				s_text_effect_finished.emit()
			TextEffects.TYPING:
				reset_text_typing()
				is_text_playing = true
			TextEffects.FADE_IN:
				print("TODO TEXT FADE IN IMPLEMENTATION")
				s_text_effect_finished.emit()
			_:
				print("NON EXISTENT TEXT EFFECT " + str(text_effect_data.text_effect))
	else:
		print("NO TEXT")

func reset_text_typing() -> void:
	image_text.visible_characters = 0
	visible_chars = 0

func complete_text() -> void:
	image_text.visible_characters = len(image_text.text)
	on_typing_effect_finished()

func on_typing_effect_finished() -> void:
	s_text_effect_finished.emit()
	is_text_playing = false

func show_continue_caret() -> void:
	caret_animation_player.play("moving")
	next_comic_caret.show()

func hide_continue_caret() -> void:
	next_comic_caret.hide()
