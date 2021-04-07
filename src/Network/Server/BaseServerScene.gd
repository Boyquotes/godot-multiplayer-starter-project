# Pretty much every scene should have a server-side script
# This script is responsible for instantiating the scene server-side and handling server logic
#
# You can add a child node in the Server scene and add a reference in the server script to access this script with Server.BaseServerScene
extends Node

var scene_path = "res://"
var scene : Node

func _ready():
	Server.connect("server_created", self, "_on_server_created")
	Server.connect("player_removed", self, "despawn_player")


# The scene is instantiated server-side here
# You can override this for custom instantiation
func _on_server_created():
	if (!get_tree().is_network_server()): return
	
	var s = load(scene_path)
	scene = s.instance()
	get_tree().root.call_deferred("add_child", scene)
