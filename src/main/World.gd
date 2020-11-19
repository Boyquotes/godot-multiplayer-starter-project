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
	
	if (pinfo.net_id != 1):
		i.set_network_master(pinfo.net_id)
	i.set_name(str(pinfo.net_id))
	
	add_child(i)
