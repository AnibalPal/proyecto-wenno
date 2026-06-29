class_name EnemyState
extends State

var enemy: Enemy
var state_machine: EnemyStateMachine

func _ready() -> void:
	await owner.ready
	enemy = owner as Enemy
	state_machine = enemy.state_machine
	assert(enemy, "The EnemyState class must only be used by an Enemy type node")
	enemy_state_ready()

# Override this in children if needed
func enemy_state_ready():
	pass
