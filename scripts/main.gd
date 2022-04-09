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
			$Campaign.load_campaign()
			change_state(GameState.LOADING_MAPS)

		GameState.LOADING_MAPS:
			print("loading maps")
			change_state(GameState.LOADING_ACTIONS)

		GameState.LOADING_ACTIONS:
			print("loading actions")
