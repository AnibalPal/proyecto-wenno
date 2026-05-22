extends Node2D

@onready var stage_startup_time: Timer = $Timers/StageStartupTime
@onready var stage_complete_time: Timer = $Timers/StageCompleteTime
@onready var game_over_time: Timer = $Timers/GameOverTime

@onready var stage_label: Label = $UI/StageLabel
@onready var clear_stage_label: Label = $UI/ClearStageLabel
@onready var game_over_label: Label = $UI/GameOverLabel

@onready var enemies: Node2D = $Enemies

@export var next_stage_path := ""

var stage_done := false

func _ready() -> void:
	assert(next_stage_path, "NO NEXT STAGE PATH SET")
	stage_startup_time.start()

func _process(_delta: float) -> void:
	check_if_clear()

func spawn_enemies() -> void:
	enemies.show()
	enemies.process_mode = Node.PROCESS_MODE_INHERIT

func start_stage() -> void:
	stage_label.hide()
	spawn_enemies()

func end_stage() -> void:
	stage_done = true
	clear_stage_label.show()
	stage_complete_time.start()

func game_over() -> void:
	game_over_label.show()
	game_over_time.start()

func check_if_clear() -> void:
	if(enemies.get_child_count() <= 0 and !stage_done):
		end_stage()

func _on_stage_startup_time_timeout() -> void:
	start_stage()

func _on_stage_complete_time_timeout() -> void:
	get_tree().change_scene_to_file(next_stage_path)

func _on_game_over_time_timeout() -> void:
	get_tree().reload_current_scene()

func _on_player_s_game_over() -> void:
	game_over()
