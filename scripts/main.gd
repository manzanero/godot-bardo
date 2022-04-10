extends Node


enum GameState {
	LOADING_CAMPAIGN
	LOADING_MAPS
	LOADING_ACTIONS
}


var game_state = GameState.LOADING_CAMPAIGN


func _ready():
	change_state(game_state)


func change_state(new_game_state):
	game_state = new_game_state
	match game_state:
		GameState.LOADING_CAMPAIGN:
			print("loading world")
			var time_start = OS.get_ticks_msec()
			$Campaign.load_campaign()
			print("Elapsed: ", OS.get_ticks_msec() - time_start)
			change_state(GameState.LOADING_MAPS)

		GameState.LOADING_MAPS:
			print("loading maps")
			change_state(GameState.LOADING_ACTIONS)

		GameState.LOADING_ACTIONS:
			print("loading actions")
