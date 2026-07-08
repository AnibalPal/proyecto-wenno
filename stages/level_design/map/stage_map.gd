@tool
class_name MapUI
extends Control

@export var stage_map_id := ""
@export_tool_button("Generate json map") var action = make_map_json

func make_map_json() -> void:
	if(Engine.is_editor_hint()):
		assert(stage_map_id, "No stage map id set")
		var json_dict := {}
		for map_node: MapNode in get_children():
			json_dict[map_node.id] = {
				"visited": map_node.visited,
				"walls": {
					"up": map_node.up_open,
					"right": map_node.right_open,
					"down": map_node.down_open,
					"left": map_node.left_open
				}
			}
		var json_string = JSON.stringify(json_dict)
		var file_path_no_name = "/".join(scene_file_path.split("/").slice(0, -1))
		var json_file_path : String = file_path_no_name + "/" + stage_map_id + "_map.json"
		var map_json_file := FileAccess.open(json_file_path, FileAccess.WRITE)
		map_json_file.store_line(json_string)
		map_json_file.close()
		var fs = EditorInterface.get_resource_filesystem()
		fs.scan()
		await fs.filesystem_changed
		print("json file saved to %s"%json_file_path)

func update_map_ui() -> void:
	var player_current_stage = PlayerData.player_progression["status"]["current_stage_id"]
	var player_current_chamber = PlayerData.player_progression["status"]["current_chamber_id"]
	var map_node_data = PlayerData.map_progression[player_current_stage][player_current_chamber]
	for child: MapNode in get_children():
		if(child.id == player_current_chamber):
			if(map_node_data.has("visited")):
				child.visited = map_node_data["visited"]
			if(map_node_data.has("walls")):
				child.up_open = map_node_data["walls"]["up"]
				child.right_open = map_node_data["walls"]["right"]
				child.down_open = map_node_data["walls"]["down"]
				child.left_open = map_node_data["walls"]["left"]
			child.player = true
		else:
			child.player = false	
