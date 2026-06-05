extends Control

@onready var sliding_container: Control = $Content/Display/SlidingContainer

@onready var status_label: RichTextLabel = $Content/Options/Status
@onready var map_label: RichTextLabel = $Content/Options/Map
@onready var settings_label: RichTextLabel = $Content/Options/Settings

@onready var status: VBoxContainer = $Content/Display/SlidingContainer/Status
@onready var settings: VBoxContainer = $Content/Display/SlidingContainer/Settings

enum Menu {
	STATUS,
	MAP,
	SETTINGS
}

var menu_positions := {
	Menu.STATUS: 0,
	Menu.MAP: -640, # Viewport size
	Menu.SETTINGS: -640 * 2 # Viewport size * 2
}

var current_menu := Menu.STATUS
var current_tween = null

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("menu_next_tab")):
		if(current_menu != Menu.SETTINGS):
			menu_transition(current_menu + 1)
	if(Input.is_action_just_pressed("menu_return_tab")):
		if(current_menu != Menu.STATUS):
			menu_transition(current_menu - 1)
	if(Input.is_action_just_pressed("pause")):
		unpause()

func unpause() -> void:
	if(current_tween and current_tween.is_running()): return
	if(!owner.pause_trigger):
		get_tree().paused = false
		hide()
	else:
		owner.pause_trigger = false

func set_active_label(new_menu: Menu) -> void:
	match new_menu:
		Menu.STATUS:
			status_label.text = "[u]Status[/u]"
			map_label.text = "Map"
			settings_label.text = "Settings"
		Menu.MAP:
			status_label.text = "Status"
			map_label.text = "[u]Map[/u]"
			settings_label.text = "Settings"
		Menu.SETTINGS:
			status_label.text = "Status"
			map_label.text = "Map"
			settings_label.text = "[u]Settings[/u]"

func set_menu_position(new_menu: Menu) -> void:
	current_menu = new_menu
	set_active_label(new_menu)
	sliding_container.position.x = menu_positions[new_menu]

func menu_transition(new_menu: Menu) -> void:
	if(current_menu == new_menu): return
	if(current_tween and current_tween.is_running()): return
	set_active_label(new_menu)
	current_menu = new_menu
	var new_x_pos = menu_positions[new_menu]
	var tween = get_tree().create_tween()
	tween.set_pause_mode(Tween.TWEEN_PAUSE_PROCESS)
	tween.tween_property(sliding_container, "position", Vector2(new_x_pos, 0), 0.3)
	current_tween = tween
