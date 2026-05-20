# This class is used to defer the combat interactions (entity attacked another one, clashes, etc.)
# to the end of the frame, then it decides which actions should happen and which shouldn't
extends Node2D

enum CombatEventType {
	CLASH, # 2 hitbox collide
	DAMAGE, # 1 hitbox and 1 hurtbox
}

# Sadly cant put the type I want because godot limitation but the type should be
# something like Dictionary[String, Array[CombatEvent]]
var event_queue = {}

func _physics_process(_delta: float) -> void:
	call_deferred("resolve_event_queue")

# Helper functions
func event_priority_sort(a : CombatEvent, b : CombatEvent) -> bool:
	if(a.type < b.type):
		return true
	return false

func instantiate_hit_effect(pos1: Vector2, pos2: Vector2, vfx_path: String) -> void:
	var vfx_position := (pos1 + pos2)/2 
	var packed_scene := load(vfx_path)
	var vfx_instance = packed_scene.instantiate()
	vfx_instance.global_position = vfx_position
	get_tree().root.add_child(vfx_instance)

# Combat event queue functions
func subscribe(event_type: CombatEventType, emitting_entity, receiving_entity, data := {}) -> void:
	if Helpers.is_wall_between(emitting_entity.global_position, receiving_entity.global_position):
		return
	var combat_event = CombatEvent.new(event_type, emitting_entity, receiving_entity, data)
	var event_group_key = emitting_entity.name + receiving_entity.name
	if(event_queue.has(event_group_key)):
		event_queue[event_group_key].append(combat_event)
	else:
		event_queue[event_group_key] = [combat_event]

func resolve_damage(event: CombatEvent) -> void:
	event.emitter.on_hit()
	if(event.data.has("damage")):
		event.receiver.on_damaged(event.data["damage"], event.emitter.global_position)
	if(event.data.has("collision_info")):
		instantiate_hit_effect(
			event.data["collision_info"]["entity1"], 
			event.data["collision_info"]["entity2"], 
			"res://VFX/player_hit_effect.tscn"
		)

func resolve_clash(event: CombatEvent) -> void:
	if(event.data.has("collision_info")):
		event.emitter.on_clash(event.data["collision_info"]["entity2"])
		event.receiver.on_clash(event.data["collision_info"]["entity1"])
		instantiate_hit_effect(
			event.data["collision_info"]["entity1"], 
			event.data["collision_info"]["entity2"],  
			"res://VFX/clash_effect.tscn"
		)

func resolve_event_queue() ->void:
	if(event_queue.size() > 0):
		for event_id in event_queue:
			var event_group = event_queue[event_id]
			event_group.sort_custom(event_priority_sort)
			for event:CombatEvent in event_group:
				match event.type:
					CombatEventType.CLASH:
						resolve_clash(event)
						break
					CombatEventType.DAMAGE:
						resolve_damage(event)
		event_queue.clear()

class CombatEvent:
	# TODO: add types considering projectiles and enemy types
	var type: CombatEventType
	var emitter
	var receiver
	var data: Dictionary = {}
	
	func _init(p_type : CombatEventType, p_emitter, p_receiver, p_data := {}) -> void:
		type = p_type
		emitter = p_emitter
		receiver = p_receiver
		data = p_data
		
	func _print() -> void:
		print(type)
		print(emitter.name)
		print(receiver.name)
