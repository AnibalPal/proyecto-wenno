class_name PlayerState
extends State

var player: Player
var state_data = PlayerStateData

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(owner.name == "Player", "The PlayerState class must only be used by the Player node")
