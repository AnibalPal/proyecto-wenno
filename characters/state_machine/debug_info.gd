extends CanvasLayer

@export var debug_active := false
# TODO: Change the player entity to something more generalized
@export var entity : Player
@export var entity_state_machine : StateMachine

# Debug variables
@onready var debug_x_velocity := $"InfoContainer/XVelocityContainer/Value"
@onready var debug_y_velocity := $"InfoContainer/YVelocityContainer/Value"
@onready var debug_state := $"InfoContainer/StateContainer/Value"

func _ready() -> void:
	if(entity.debug_mode):
		show()

func _process(_delta: float) -> void:
	if(entity.debug_mode):
		update_debug_info(
			entity.velocity.x, 
			entity.velocity.y, 
			entity_state_machine.current_state.name
		)

func update_debug_info(x_velocity : float, y_velocity : float, state : String):
	debug_x_velocity.text = str(x_velocity)
	debug_y_velocity.text = str(y_velocity)
	debug_state.text = state
