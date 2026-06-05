class_name Chamber
extends Node2D

@export var id := ""

@onready var entries: Node2D = $Entries
@onready var exits: Node2D = $Exits

signal s_change_chamber(next_chamber_path: String, next_entry: String, direction: String)

func _ready() -> void:
	assert(id, "%s: No id set!" % name)
	prepare_exit_areas()

# Can return Vector2 or null
func get_entry_node(entry_name : String) -> Variant:
	for child: ChamberEntry in entries.get_children():
		if child.name == entry_name:
			return child
	return null

func prepare_exit_areas() -> void:
	for child: ChamberExit in exits.get_children():
		child.area_entered.connect(_on_exit_area_entered.bind(child.next_chamber_path, child.next_entry_name, child.direction))

func _on_exit_area_entered(_area: Area2D, next_chamber_path: String, next_entry: String, direction: String) -> void:
	s_change_chamber.emit(next_chamber_path, next_entry, direction)
