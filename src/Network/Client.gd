# Handles server connection/disconnection and client data
extends Node


signal join_success                            # When the peer successfully joins a server
signal join_fail                               # Failed to join a server
signal player_list_updated                     # This peer playerlist has been updated


# Store player info here. You can add as many entries as you like
# Like score, level, XP etc.
var player_info = {
	name = "Player",
	net_id = 1,                                        # The players ID over the network, it is unique
	actor_path = "res://src/Main/Player/Player.tscn",  # The class used to represent the player in the game world
	char_color = Color(1, 1, 1)
}


# The client keeps a list of all the other players
var players = {}


# Connect signals on start
func _ready():
	get_tree().connect("connected_to_server", self, "_on_connected_to_server")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	get_tree().connect("server_disconnected", self, "_on_disconnected_from_server")


func join_server(ip, port):
	var net = NetworkedMultiplayerENet.new()
	
	if (net.create_client(ip, port) != OK):
		print("Failed to create client")
		emit_signal("join_fail")
		return
		
	get_tree().set_network_peer(net)


# This is called by the server or other clients
# Add a new player to the player_list dictionary
remote func register_player(pinfo):
	if (get_tree().is_network_server()): return
	players[pinfo.net_id] = pinfo
	emit_signal("player_list_updated")


# Remove a player from the player_list dictionary
remote func unregister_player(id):
	if (get_tree().is_network_server()): return
	players.erase(id)
	emit_signal("player_list_updated")


# Wrapper function for rset
# The difference with rset is that it doesn't call the function on the server
func rset_client(node : Node, property : String, value):
	for id in Client.players:
		if id != player_info.net_id:
			node.rset_id(id, property, value)


# Peer trying to connect to server is notified on success
func _on_connected_to_server():
	# Update the player_info dictionary with the obtained unique network ID
	player_info.net_id = get_tree().get_network_unique_id()
	
	# Request the server to register this new player across all connected players
	Server.rpc_id(1, "register_player", player_info)
	
	# And register itself on the local list
	register_player(player_info)
	
	emit_signal("join_success")


# Peer trying to connect to server is notified on failure
func _on_connection_failed():
	emit_signal("join_fail")
	get_tree().set_network_peer(null)


# Peer is notified when disconnected from server
func _on_disconnected_from_server():
	print("Disconnected from server")
	# Clear the internal player list
	players.clear()
	# Reset the player info network ID
	player_info.net_id = 1
