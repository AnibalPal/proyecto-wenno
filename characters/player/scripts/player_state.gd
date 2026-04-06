class_name PlayerState
extends State

const IDLE := "Idle"
const RUN := "Run"
const JUMP := "Jump"
const FALL := "Fall"

var player: Player

func _ready() -> void:
	await owner.ready
	player = owner as Player
	assert(owner.name == "Player", "The PlayerState class must only be used by the Player node")
