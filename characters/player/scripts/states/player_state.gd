class_name PlayerState
extends State

var player: Player
var state_data = PlayerStateData

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(owner.name == "Player" or owner.name == "DebugPlayer", "The PlayerState class must only be used by the Player node")
	player_state_ready()

# Override this in children if needed
func player_state_ready():
	pass
