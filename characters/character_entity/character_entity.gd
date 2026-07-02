@tool
class_name CharacterEntity
extends CharacterBody2D

# TODO: while it is important that this is a tool script to set the entities
# without worrying about orientation and whatnot in the editor, this script extends 
# many others that should also use the @tool anotation, it's really annoying 
# having to check in those scripts what should and shouldn't run on the editor,
# so I should try to separate the tool parts in another node

# Variable used inside class children to show important data
@export var debug_mode := false

# Only required node
@onready var should_rotate := $"ShouldRotate"

# Global vars
@export var facing_right := true:
	set(value):
		facing_right = value
		if(Engine.is_editor_hint() and should_rotate != null):
			if(value):
				should_rotate.transform.x = Vector2(1.0, 0.0)
			else:
				should_rotate.transform.x = Vector2(-1.0, 0.0)
	get:
		return facing_right


func _ready() -> void:
	# Apply the initial rotation to the should_rotate node, this is only neccesary for the node
	# to be consistent with the editor because I could not do it in the setter coz godot things
	if(facing_right):
		should_rotate.transform.x = Vector2(1.0, 0.0)
	else:
		should_rotate.transform.x = Vector2(-1.0, 0.0)
	character_ready()

# Custom ready func to be overriden in children if needed	
func character_ready() -> void:
	pass

# Utility functions to be used inside PlayerState or Enemy scripts
func turn_around() -> void:
	if(facing_right):
		turn_left()
	else:
		turn_right()

func turn_right() -> void:
	if(facing_right): return
	facing_right = true
	should_rotate.transform.x = Vector2(1.0, 0.0)

func turn_left() -> void:
	if(!facing_right): return
	facing_right = false
	should_rotate.transform.x = Vector2(-1.0, 0.0)

# Move forward based on a positive speed value (scalar value)
func move_forward(speed: float) -> void:
	if(facing_right):
		velocity.x = speed
	else:
		velocity.x = -speed

func move_backwards(speed: float) -> void:
	if(facing_right):
		velocity.x = -speed
	else:
		velocity.x = speed

# Editor tool functions
func tool_update_jump_trayectory() -> void:
	if(Engine.is_editor_hint()):
		var draw_jump_node := get_node_or_null("EditorTools/DrawJumpPath")
		if(draw_jump_node):
			draw_jump_node.draw_jump_arc()

# Virtual functions used in the CombatManager class
func on_damaged(_damage: int, _other_entity_position: Vector2) -> void:
	pass

func on_hit() -> void:
	pass
		
func on_clash(_other_collision_position: Vector2) -> void:
	pass
