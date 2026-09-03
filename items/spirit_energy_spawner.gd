extends Node2D
class_name SpiritEnergySpawner

signal s_reward_complete

@export var spirit_scene : PackedScene
@export var spirit_amount := 0

@onready var spawn_area: BoxArea = $SpawnArea	

var current_spirit_amount := 0

func _ready() -> void:
	current_spirit_amount = spirit_amount

func begin(target : Node2D) -> void:
	for i in range(spirit_amount):
		var spawn_pos = spawn_area.sample_point()
		spawn_energy(spawn_pos, target)
		await get_tree().create_timer(0.1).timeout

func spawn_energy(spawn_pos : Vector2, new_target : Node2D) -> void:
	var spirit_instance = spirit_scene.instantiate()
	get_tree().root.call_deferred("add_child", spirit_instance)
	await  spirit_instance.ready
	(spirit_instance as SpiritEnergy).s_spirit_consumed.connect(on_spirit_consumed)
	(spirit_instance as SpiritEnergy).set_start_position(spawn_pos)
	(spirit_instance as SpiritEnergy).begin_move_to_target(new_target)

func on_spirit_consumed() -> void:
	current_spirit_amount -= 1
	if(current_spirit_amount <= 0):
		s_reward_complete.emit()
