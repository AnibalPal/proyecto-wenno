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
			FALL: true,
			ATTACK: true,
			AIRATTACK: true
		},
		ALL: {
			HIT: true,
			RECOIL: true
		},
		HIT: {
			ALL: true
		},
		RECOIL: {
			ALL: true
		}
}
