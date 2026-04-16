class_name PlayerStateData

const IDLE := "Idle"
const RUN := "Run"
const JUMP := "Jump"
const FALL := "Fall"
const ATTACK := "Attack"
const AIRATTACK := "AirAttack"

static var transitions = {
		IDLE: {
			RUN: true,
			FALL: true,
			JUMP: true,
			ATTACK: true
		},
		RUN: {
			IDLE: true,
			FALL: true,
			JUMP: true,
			ATTACK: true
		},
		FALL: {
			IDLE: true,
			RUN: true,
			JUMP: true,
			ATTACK: true,
			AIRATTACK: true
		},
		JUMP: {
			FALL: true,
			AIRATTACK: true
		},
		ATTACK: {
			IDLE: true,
			RUN: true
		},
		AIRATTACK: {
			IDLE: true,
			RUN: true,
			JUMP: true,
			FALL: true
		}
}
