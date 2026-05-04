extends Node2D

@export var enemy : PackedScene

@onready var enemy_spawn_position: Node2D = $EnemySpawnPosition

func _process(_delta: float) -> void:
	if(Input.is_action_just_pressed("debug_enemy_spawn")):
		instantiate_enemy()

func instantiate_enemy() -> void:
	var enemy_instance = enemy.instantiate()
	enemy_instance.health = 3
	enemy_instance.global_position = enemy_spawn_position.global_position
	add_child(enemy_instance)
