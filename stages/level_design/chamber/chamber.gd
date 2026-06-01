class_name Chamber
extends Node2D

@onready var exits: Node2D = $Exits
@onready var start_position_node: EditorIconTool = $StartPosition

signal s_change_chamber(next_chamber_path: String)

func _ready() -> void:
	prepare_exit_areas()

func prepare_exit_areas() -> void:
	for child: ChamberExit in exits.get_children():
		child.area_entered.connect(_on_exit_area_entered.bind(child.next_chamber_path))

func _on_exit_area_entered(_area: Area2D, next_chamber_path : String) -> void:
	s_change_chamber.emit(next_chamber_path)
