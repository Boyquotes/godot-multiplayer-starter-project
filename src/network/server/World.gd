extends Node

var _world : Node2D


func _ready():
	get_parent().connect("server_created", self, "_on_server_created")


func _on_server_created():
	create_world()


func create_world():
	if (!get_tree().is_network_server()): return
	
	var w = load("res://src/main/World.tscn")
	_world = w.instance()
	get_tree().root.call_deferred("add_child", _world)


# Tell players to spawn a new player
remote func spawn_players(pinfo : Dictionary):
	var spawn_index = 0
	
	# For each player
	for id in Server.players:
		
		# If this is not the player calling the func
		if id != pinfo.net_id:
			# Spawn the current player to them
			_world.rpc_id(pinfo.net_id, "spawn_player", Server.players[id], spawn_index)
		
		# In any case, spawn the new player in all players
		_world.rpc_id(id, "spawn_player", pinfo, Server.players.size() - 1)
		spawn_index += 1
