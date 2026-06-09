@tool
class_name MapNode
extends Control

# NOTE to self: can't use dictionary because the inspector does not support fixed keys,
# the option is to make a resource but I don't really like that option

@export var id := ""

@export_group("Status")
@export var visited: bool:
	set(value):
		visited = value
		if(value):
			show()
		else:
			hide()

@export_group("Walls")
@export var up_open: bool:
	set(value):
		up_open = value
		if(up_open_wall):
			if(value): 
				up_open_wall.show()
			else:
				up_open_wall.hide()

@export var right_open: bool:
	set(value):
		right_open = value
		if(right_open_wall):
			if(value): 
				right_open_wall.show()
			else:
				right_open_wall.hide()
				
@export var down_open: bool:
	set(value):
		down_open = value
		if(down_open_wall):
			if(value): 
				down_open_wall.show()
			else:
				down_open_wall.hide()

@export var left_open: bool:
	set(value):
		left_open = value
		if(left_open_wall):
			if(value): 
				left_open_wall.show()
			else:
				left_open_wall.hide()

@export_group("Icons")
@export var player: bool:
	set(value):
		player = value
		if(player_icon):
			if(value):
				player_icon.show()
			else:
				player_icon.hide()

@onready var up_open_wall: ColorRect = $Up/Open
@onready var right_open_wall: ColorRect = $Right/Open
@onready var down_open_wall: ColorRect = $Down/Open
@onready var left_open_wall: ColorRect = $Left/Open
@onready var player_icon : TextureRect = $"PlayerIcon"

func _ready() -> void:
	up_open_wall.visible = up_open
	right_open_wall.visible = right_open
	down_open_wall.visible = down_open
	left_open_wall.visible = left_open
	player_icon.visible = player
	visited = visited
