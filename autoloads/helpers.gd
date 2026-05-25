extends Node2D

func is_wall_between(pos1: Vector2, pos2: Vector2) -> bool:
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(pos1, pos2, 1)
	var result = space_state.intersect_ray(query)
	# return true if there is a collision with a wall
	return !result.is_empty()
