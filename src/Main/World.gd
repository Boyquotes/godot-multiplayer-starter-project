# Client side World script
extends Node2D


func _ready():
	if (!get_tree().is_network_server()):
		Server.World.rpc_id(1, "spawn_players", Client.player_info)


# Spawns a new player actor, using the provided player_info structure and the given spawn index
remote func spawn_player(pinfo, spawn_index = -1):
	if spawn_index == -1:
		spawn_index = Client.players.size()
	
	# Load the scene and create an instance
	var actor_class = load(pinfo.actor_path)
	var i = actor_class.instance()
	
	i.set_dominant_color(pinfo.char_color)
	i.position = $SpawnPoints.get_node(str(spawn_index)).position
	
	i.set_network_master(pinfo.net_id)
	i.set_name(str(pinfo.net_id))
	
	add_child(i)


remote func despawn_player(pinfo):
	# Try to locate the player actor
	var player_node = get_node(str(pinfo.net_id))
	if (!player_node):
		print("Cannoot remove invalid node from tree")
		return
	
	# Mark the node for deletion
	player_node.queue_free()
