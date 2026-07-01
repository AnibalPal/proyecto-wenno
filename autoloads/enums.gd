extends Node

enum CutsceneCommonActions {
	HIDE,
	SHOW,
	MOVE,
	WALK,
	TALK,
	ANIMATION,
	WAIT,
	INSTANTIATE
}

const CUTSCENE_EXPECTED_DATA = {
	CutsceneCommonActions.HIDE : null,
	CutsceneCommonActions.SHOW : null,
	CutsceneCommonActions.MOVE : {
		"x" : 0
	},
	CutsceneCommonActions.WALK : null,
	CutsceneCommonActions.TALK : {
		"text": "",
		"width": 240
	},
	CutsceneCommonActions.ANIMATION : null,
	CutsceneCommonActions.WAIT : null,
	CutsceneCommonActions.INSTANTIATE : null
}
