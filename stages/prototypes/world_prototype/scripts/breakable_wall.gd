extends StaticBody2D

func _on_hurtbox_area_entered(_area: Area2D) -> void:
	print("play SFX")
	print("play VFX")
	queue_free()
