@tool
class_name CutsceneAction
extends Resource

@export var entity := ""
@export var action := Enums.CutsceneCommonActions.SHOW:
	set(value):
		action = value
		var expected_data = {}
		if(Enums.CUTSCENE_EXPECTED_DATA[action]):
			for key in Enums.CUTSCENE_EXPECTED_DATA[action]:
				expected_data[key] = Enums.CUTSCENE_EXPECTED_DATA[action][key]
		data = expected_data

@export var data := {}
