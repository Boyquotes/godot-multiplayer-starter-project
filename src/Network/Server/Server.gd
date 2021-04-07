extends Node

signal server_created
signal player_list_updated
signal player_removed(pinfo)


onready var World = $World


var server_info = {
	name = "Server",
	max_players = 10,      # Maximum allowed connections
	used_port = 1111       # Listening port
}


var players = {}     # Store all the players info


# This is called by Start script
func create_server():
	# Initialize the networking system
	var net = NetworkedMultiplayerENet.new()
	
	# Try to create the server
	if (net.create_server(server_info.used_port, server_info.max_players) != OK):
		print("Failed to create server")
		return
	
	# Assign it into the tree
	get_tree().set_network_peer(net)
	
	# Connect signals
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")
	
	print("Server created successfully")
	emit_signal("server_created")



# Called remotely by clients
# Register a new player to the server and then send its info to all other clients
remote func register_player(pinfo):
	if (get_tree().is_network_server()):
		for id in players:
			# Give playerlist to the new player
			Client.rpc_id(pinfo.net_id, "register_player", players[id])
			# Give the new player info to all the players
			Client.rpc_id(id, "register_player", pinfo)
			
		print("Registered player ", pinfo.name, " (", pinfo.net_id, ") to internal player table")
	
	players[pinfo.net_id] = pinfo          # Create the player entry in the server dic
	emit_signal("player_list_updated")     # And notify that the player list has been changed



# Unregister a player when it disconnects or quits
func unregister_player(id):
	print("Removing player ", players[id].name, " from internal table")
	
	# Remove the player from the list
	players.erase(id)
	
	# And notify everyone the list has been changed
	emit_signal("player_list_updated")
	emit_signal("player_removed", players[id])



func _on_player_connected(id):
	pass



# When a player disconnects, the server unregisters it and tell all clients to do so
func _on_player_disconnected(id):
	if (get_tree().is_network_server()):
		print(String(Server.players[id].name) + " - " + String(id) + " disconnected")
		unregister_player(id)
		Client.rpc("unregister_player", id)
