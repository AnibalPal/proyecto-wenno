extends Node

@onready var invisible_walls: TileMapLayer = $"../World/InvisibleWalls"

@onready var vastago_1: Vastago = $"../Cutscenes/Cutscene1/Entities/Vastago1"
@onready var vastago_2: Vastago = $"../Cutscenes/Cutscene1/Entities/Vastago2"

var remaining_enemies := 2

func _ready() -> void:
	vastago_1.s_enemy_defeated.connect(on_enemy_defeated)
	vastago_2.s_enemy_defeated.connect(on_enemy_defeated)

func on_enemy_defeated() -> void:
	print("ENEMY DEFEATED")
	remaining_enemies -= 1
	check_all_enemies_defeated()

func check_all_enemies_defeated() -> void:
	if(remaining_enemies <= 0):
		invisible_walls.queue_free()

func change_scene_to_main_menu() -> void:
	get_tree().change_scene_to_file("res://postulacion_fondo_2026/main_menu_postulacion_fondo.tscn")

func _on_stage_complete_area_entered(_area: Area2D) -> void:
	call_deferred("change_scene_to_main_menu")
