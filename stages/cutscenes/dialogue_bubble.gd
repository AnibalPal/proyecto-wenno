class_name DialogueBubble
extends Control

signal s_dialogue_complete

@onready var animated_dialogue_bubble: PanelContainer = $AnimatedDialogueBubble
@onready var text_content: RichTextLabel = $AnimatedDialogueBubble/MarginContainer/TextContent
@onready var dialogue_bubble_measurer: PanelContainer = $DialogueBubbleMeasurer
@onready var dialogue_bubble_measurer_text_content: RichTextLabel = $DialogueBubbleMeasurer/MarginContainer/TextContent

@export var dialogue_text := ""
@export var minimum_bubble_width := 240
@export var play_speed := 1

var text_count := 0.0
var dialogue_playing := false

func _ready() -> void:
	var expected_dialogue_bubble_size = await get_expected_dialogue_bubble_size()
	var expand_dialogue_bubble_tween := create_tween()
	# Vector to center the dialogue bubble on the x axis but move it fully up depending on its size
	# This makes it easier to add the dialogue to the cutscene entities
	var dialogue_bubble_offset = -Vector2(expected_dialogue_bubble_size.x/2.0, expected_dialogue_bubble_size.y)
	animated_dialogue_bubble.position = dialogue_bubble_offset
	expand_dialogue_bubble_tween.tween_property(animated_dialogue_bubble, "size", expected_dialogue_bubble_size, 0.1)
	expand_dialogue_bubble_tween.finished.connect(ready_text)

func ready_text() -> void:
	text_content.text = dialogue_text
	dialogue_playing = true
	text_content.visible_characters = 0

func _process(_delta: float) -> void:
	if(dialogue_playing):
		text_count += _delta * play_speed
		text_content.visible_characters = int(text_count)
		if(text_content.visible_characters >= text_content.text.length()):
			dialogue_playing = false
	if(Input.is_action_just_pressed("cutscene_next")):
		next()

func get_expected_dialogue_bubble_size() -> Vector2:
	dialogue_bubble_measurer.size = Vector2(minimum_bubble_width, 0)
	await dialogue_bubble_measurer_text_content.resized
	dialogue_bubble_measurer_text_content.text = dialogue_text
	await dialogue_bubble_measurer_text_content.resized
	return dialogue_bubble_measurer_text_content.size

func next() -> void:
	if(dialogue_playing):
		text_content.visible_characters = -1
		dialogue_playing = false
	else:
		complete_dialogue()

func complete_dialogue() -> void:
	text_content.text = ""
	var shrink_tween = create_tween()
	shrink_tween.tween_property(animated_dialogue_bubble, "size", Vector2.ZERO, 0.1)
	shrink_tween.finished.connect(free_bubble)

func free_bubble() -> void:
	s_dialogue_complete.emit()
	queue_free()
