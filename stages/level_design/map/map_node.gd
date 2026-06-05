@tool
class_name MapNode
extends Control

# NOTE to self: can't use dictionary because the inspector does not support fixed keys,
# the option is to make a resource but I don't really like that option

@export var id := ""

@export_group("Status")
@export var visited := false:
	set(value):
		visited = value
		if(value):
			show()
		else:
			hide()

@export_group("Walls")
@export var up_open := false:
	set(value):
		if(up_open_wall):
			up_open = value
			if(value): 
				up_open_wall.show()
			else:
				up_open_wall.hide()

@export var right_open := false:
	set(value):
		if(right_open_wall):
			right_open = value
			if(value): 
				right_open_wall.show()
			else:
				right_open_wall.hide()
				
@export var down_open := false:
	set(value):
		if(down_open_wall):
			down_open = value
			if(value): 
				down_open_wall.show()
			else:
				down_open_wall.hide()

@export var left_open := false:
	set(value):
		if(left_open_wall):
			left_open = value
			if(value): 
				left_open_wall.show()
			else:
				left_open_wall.hide()

@export_group("Icons")
@export var player := false:
	set(value):
		if(player_icon):
			player = value
			if(value):
				player_icon.show()
			else:
				player_icon.hide()

@onready var up_open_wall: ColorRect = $Up/Open
@onready var right_open_wall: ColorRect = $Right/Open
@onready var down_open_wall: ColorRect = $Down/Open
@onready var left_open_wall: ColorRect = $Left/Open
@onready var player_icon : TextureRect = $"PlayerIcon"
