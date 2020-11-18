extends Node

signal server_created
signal player_list_updated

var server_info = {
	name = "Server",      # Holds the name of the server
	max_players = 10,      # Maximum allowed connections
	used_port = 1111         # Listening port
}


var players = {}     # Store all the players info


func _ready():
	# Those are necessary to prevent Server to be deleted
	get_tree().connect("network_peer_connected", self, "on_player_connected")
	get_tree().connect("network_peer_disconnected", self, "on_player_disconnected")


func create_server():
	# Initialize the networking system
	var net = NetworkedMultiplayerENet.new()
	
	# Try to create the server
	if (net.create_server(server_info.used_port, server_info.max_players) != OK):
		print("Failed to create server")
		return
	
	# Assign it into the tree
	get_tree().set_network_peer(net)
	emit_signal("server_created")
	print("Server created successfully")


# Called remotely by clients
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



func on_player_connected(id):
	if get_tree().is_network_server():
		print(String(id) + " connected")

func on_player_disconnected(id):
	if get_tree().is_network_server():
		print(String(id) + " disconnected")
