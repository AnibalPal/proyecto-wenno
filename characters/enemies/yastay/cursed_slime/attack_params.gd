class_name AttackParams
extends Node

# TODO: make a resource and a list of resources for attacks
@export var attack_anim_name := "attack"
@export var attack_hitbox : EnemyHitbox
@export var active_frames_start := 0
@export var active_frames_end := 1
@export var damage := 1
@export var priority := 1
	
func _ready() -> void:
	pass

func _on_frame_changed() -> void:
	#NOTE: does not trigger for frame 0
	if(self.animation == attack_anim_name):
		if(self.frame == active_frames_start):
			attack_hitbox.enable()
		
		if(self.frame == active_frames_end):
			attack_hitbox.disable()
			
		
