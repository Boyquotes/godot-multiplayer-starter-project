# Server-side script for World.tscn
# Pretty much every scene should inherit BaseServerScene to handle server side logic
# The World scene is automatically instantiated server-side
extends "res://src/Network/Server/BaseServerScene.gd"


func _ready():
	scene_path = "res://src/Main/World.tscn"
	._ready()


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


remote func despawn_player(pinfo):
	for id in Server.players:
		# Skip despawn player on the player we want to despawn
		if id == pinfo.net_id:
			continue
		
		# Replicate despawn into currently iterated player
		_world.rpc_id(id, "despawn_player", pinfo)
