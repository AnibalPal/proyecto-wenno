extends Node

enum CombatEventType {
	CLASH, # 2 hitbox collide
	DAMAGE, # 1 hitbox and 1 hurtbox
}

var event_queue: Array[CombatEvent] = []

func _physics_process(_delta: float) -> void:
	call_deferred("resolve_event_queue")

func event_priority_sort(a : CombatEvent, b : CombatEvent) -> bool:
	if(a.type < b.type):
		return true
	return false

func instantiate_hit_effect(pos1: Vector2, pos2: Vector2, vfx_path: String):
	var vfx_position := (pos1 + pos2)/2 
	var packed_scene := load(vfx_path)
	var vfx_instance = packed_scene.instantiate()
	vfx_instance.global_position = vfx_position
	get_tree().root.add_child(vfx_instance)

func subscribe(event_type: CombatEventType, emmiting_entity, receiving_entity, data := {}):
	var combat_event = CombatEvent.new(event_type, emmiting_entity, receiving_entity, data)
	event_queue.append(combat_event)

func resolve_damage(event: CombatEvent):
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
	print("RESOLVE_CLASH")
	if(event.data.has("collision_info")):
		event.emitter.on_clash(event.data["collision_info"]["entity2"])
		event.receiver.on_clash(event.data["collision_info"]["entity1"])
		instantiate_hit_effect(
			event.data["collision_info"]["entity1"], 
			event.data["collision_info"]["entity2"],  
			"res://VFX/clash_effect.tscn"
		)

func resolve_event_queue():
	if(len(event_queue) > 0):
		print("EVENTS FOR THIS FRAME: ", len(event_queue))
		event_queue.sort_custom(event_priority_sort)
		for event:CombatEvent in event_queue:
			event._print()
			match event.type:
				# REFACTOR: Consider just passing the event to the function instead
				CombatEventType.CLASH:
					resolve_clash(event)
					event_queue.clear()
					return
				CombatEventType.DAMAGE:
					resolve_damage(event)
		event_queue.clear()

class CombatEvent:
	var type: CombatEventType
	var emitter: Node2D
	var receiver: Node2D
	var data: Dictionary = {}
	
	func _init(p_type, p_emitter, p_receiver, p_data := {}) -> void:
		type = p_type
		emitter = p_emitter
		receiver = p_receiver
		data = p_data
	
	func _print() -> void:
		print(type)
		print(emitter.name)
		print(receiver.name)
