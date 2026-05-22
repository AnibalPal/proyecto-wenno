class_name PlayerStateMachine
extends StateMachine

@onready var hitboxes: Node2D = $"../ShouldRotate/Hitboxes"
@onready var hurtbox: PlayerHurtbox = $"../ShouldRotate/Hurtbox"

var state_data = PlayerStateData

func _ready() -> void:
	prepare_hitboxes()
	check_state_machine()
	state_machine_ready()

func is_transition_active(from: String, to: String) -> bool:
	# Check if its a special state that can be accesed from and to any state
	if(state_data.transitions[PlayerStateData.ALL].has(to)):
		return state_data.transitions[PlayerStateData.ALL][to]
	
	if(state_data.transitions[from].has(PlayerStateData.ALL)):
		return state_data.transitions[from][PlayerStateData.ALL]
	
	if(state_data.transitions[from].has(to)):
		return state_data.transitions[from][to]
	else:
		push_warning("TRANSICION NO EXISTENTE: " + from + " -> " + to)
		return false

# NOTE: override from StateMachine to add transition check
func transition_to_next_state(next_state_path: String, data := {}) -> void:
	if(current_state):
		if(is_transition_active(current_state.name, next_state_path)):
			current_state = get_node(next_state_path)
			current_state.enter(data)

func disable_state(to_disable: String) -> void:
	# Disable the "all" states
	if(state_data.transitions[state_data.ALL].has(to_disable)):
		state_data.transitions[state_data.ALL][to_disable] = false
	
	# Disable all states that point to the to_disable state
	for from_state in state_data.transitions:
		if state_data.transitions[from_state].has(to_disable):
			state_data.transitions[from_state][to_disable] = false
	# Disable all transitions form the state to disable
	for to_state in state_data.transitions[to_disable]:
		state_data.transitions[to_disable][to_state] = false

func check_state_machine() -> void:
	# Disable transitions depending on state's active variable
	for child: PlayerState in get_children():
		assert(child is PlayerState, "ERROR: Child is not of type PlayerState, make sure that all the PlayerStateMachine children are of type PlayerState")
		if(!child.active):
			disable_state(child.name)

# TODO: Complete then add it to instance_hit_effect function to place the effect in the proper position
func get_collision_points_between_areas(_area1: Area2D, _area2: Area2D) -> Array:
	return []

func get_collision_shape_from_idx(area: Area2D, index: int) -> CollisionShape2D:
	return area.get_children()[index]	

func prepare_hitboxes() -> void:
	for hitbox: PlayerHitbox in hitboxes.get_children():
		hitbox.area_shape_entered.connect(_on_area_shape_entered.bind(hitbox))

func on_damaged(_damage: int, enemy_position: Vector2) -> void:
	transition_to_next_state(state_data.HIT, 
		{
			"interaction_data" : {
				"area_position" : enemy_position
			}
		}
	)
	pass

func on_hit() -> void:
	pass
		
func on_clash(enemy_collision_position: Vector2) -> void:
	transition_to_next_state(state_data.RECOIL, {
		"interaction_data" : {
			"area_position" : enemy_collision_position
		}
	})

# Hurtbox and hitbox events
# Will probably have to make a function to iterate over all hitboxes to connect the event signal to the proper function instead of doing this on every hitbox
func _on_hurtbox_area_entered(_area: EnemyHitbox) -> void:
	# Getting hit event
	CombatManager.subscribe(CombatManager.CombatEventType.DAMAGE, _area.owner, owner, {
		"damage": _area.get_damage(),
		"collision_info": {
			"entity1": hurtbox.global_position,
			"entity2": _area.global_position,
			"player_damaged": true 
		}
	})

# Handle weapon VFX when attacking an enemy mostly
func _on_area_shape_entered(_area_rid: RID, area: Area2D, area_shape_idx: int, local_shape_idx: int, local_area: Area2D):
	var local_shape = get_collision_shape_from_idx(local_area, local_shape_idx)
	var other_shape = get_collision_shape_from_idx(area, area_shape_idx)
	
	if(area is EnemyHitbox):
		# Clash event
		CombatManager.subscribe(CombatManager.CombatEventType.CLASH, owner, area.owner, {
			"collision_info": {
				"entity1": local_shape.global_position,
				"entity2": other_shape.global_position,
			}
		})
		return
	
	if(area is EnemyHurtbox):
		# Hitting an enemy event
		print(area.owner.counter_hit_state)
		CombatManager.subscribe(CombatManager.CombatEventType.DAMAGE, owner, area.owner, {
			"damage": local_area.get_damage(),
			"collision_info": {
				"entity1": local_shape.global_position,
				"entity2": other_shape.global_position,
				"player_damaged": false,
				"counter_hit": area.owner.counter_hit_state
			}
		})
		return
