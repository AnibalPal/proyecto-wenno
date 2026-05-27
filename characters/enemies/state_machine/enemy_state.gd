class_name EnemyState
extends State

var enemy: Enemy

func _ready() -> void:
	await owner.ready
	enemy = owner as Enemy
	assert(enemy, "The EnemyState class must only be used by an Enemy type node")
	enemy_state_ready()

# Override this in children if needed
func enemy_state_ready():
	pass
