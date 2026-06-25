@tool
class_name PlayerHitbox
extends Box

@export var collision_color := Color("#f727446b")
@export var damage := 1

func get_damage() -> int:
	return damage

func _ready() -> void:
	if(!Engine.is_editor_hint()):
		disable()

func _process(_delta: float) -> void:
	if(Engine.is_editor_hint()):
		for collision_shape: CollisionShape2D in get_children():
			collision_shape.debug_color = collision_color
