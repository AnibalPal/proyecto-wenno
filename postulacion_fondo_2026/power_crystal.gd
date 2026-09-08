extends Node2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var spirit_energy_spawner: SpiritEnergySpawner = $SpiritEnergySpawner
@onready var spirit_energy_spawner_2: SpiritEnergySpawner = $SpiritEnergySpawner2
@onready var spirit_energy_spawner_3: SpiritEnergySpawner = $SpiritEnergySpawner3

var state := 0

func _on_area_2d_area_entered(_area: Area2D) -> void:	
	if(state < 3):
		state += 1
		if(state == 1):
			spirit_energy_spawner.begin(_area.owner)
			animated_sprite_2d.play("cracked")
		
		if(state == 2):
			spirit_energy_spawner_2.begin(_area.owner)
			animated_sprite_2d.play("more_cracked")
		
		if(state == 3):
			spirit_energy_spawner_3.begin(_area.owner)
			animated_sprite_2d.hide()
			spirit_energy_spawner_3.s_reward_complete.connect(queue_free)
