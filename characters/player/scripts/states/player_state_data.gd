class_name PlayerStateData

const IDLE := "Idle"
const RUN := "Run"
const JUMP := "Jump"
const FALL := "Fall"

static var transitions = {
		IDLE: {
			RUN: true,
			FALL: true,
			JUMP: true
		},
		RUN: {
			IDLE: true,
			FALL: true,
			JUMP: true
		},
		FALL: {
			IDLE: true,
			RUN: true,
			JUMP: true
		},
		JUMP: {
			FALL: true,
		},
}
