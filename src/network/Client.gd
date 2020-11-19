extends Node


signal join_success                            # When the peer successfully joins a server
signal join_fail                               # Failed to join a server
signal player_list_updated                     # This peer playerlist has been updated


onready var Server = $"/root/Server"

var player_info = {
	name = "Player",                   # How this player will be shown within the GUI
	net_id = 1,                        # By default everyone receives "server ID"
	actor_path = "res://src/main/player/Player.tscn",  # The class used to represent the player in the game world
	char_color = Color(1, 1, 1)        # By default don't modulate the icon color
}

var players = {}     # The clients player list


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


remote func register_player(pinfo):
	if (get_tree().is_network_server()): return
	players[pinfo.net_id] = pinfo          # Create the player entry in the dictionary
	emit_signal("player_list_updated")     # And notify that the player list has been changed


remote func unregister_player(id):
	if (get_tree().is_network_server()): return
	players.erase(id)
	emit_signal("player_list_updated")


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
