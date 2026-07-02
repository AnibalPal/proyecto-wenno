class_name PlayerStateData

# Special transition
const ALL := "All"

const IDLE := "Idle"
const RUN := "Run"
const JUMP := "Jump"
const FALL := "Fall"
const ATTACK := "Attack"
const AIRATTACK := "AirAttack"
const HIT := "Hit"
const RECOIL := "Recoil"
const CUTSCENE := "Cutscene"

static var transitions = {
		IDLE: {
			RUN: true,
			FALL: true,
			JUMP: true,
			ATTACK: true
		},
		RUN: {
			RUN: true,
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
			RUN: true,
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
			FALL: true,
			ATTACK: true,
			AIRATTACK: true
		},
		HIT: {
			ALL: true
		},
		RECOIL: {
			ALL: true
		},
		ALL: {
			HIT: true,
			RECOIL: true,
			CUTSCENE: true,
			IDLE: true
		}
}
