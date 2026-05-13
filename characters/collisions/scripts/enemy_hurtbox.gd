@tool
extends Box
class_name EnemyHurtbox

@export var collision_color := Color("#9c5dff6b")

func _process(_delta: float) -> void:
	if(Engine.is_editor_hint()):
		for collision_shape: CollisionShape2D in get_children():
			collision_shape.debug_color = collision_color
