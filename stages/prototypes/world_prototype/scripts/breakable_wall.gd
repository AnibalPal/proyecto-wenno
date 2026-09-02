extends StaticBody2D

# HACK
var counter_hit_state := false

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	# TODO: play SFX
	# TODO: play VFX
	queue_free()
