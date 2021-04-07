# This is the script executed at the start of the project
# It can handle command line arguments
extends Node


var default_server = false                                         # Does this default to the server when no arguments are passed
var main_scene : PackedScene = load("res://src/Ui/MainMenu.tscn")  # What is the starting scene


# Handles command line arguments and start the corresponding scenes
func _ready():
	var args = OS.get_cmdline_args()
	
	# This is a bit less efficient but more readable
	if "--server" in args:
		start_as_server()
	elif "--client" in args :
		start_as_client()
	else:
		if default_server: start_as_server()
		else: start_as_client()
	
	queue_free()


# Start the project as a headless server
func start_as_server():
	print("Starting dedicated server")
	Server.create_server()


# Start the project as a client
func start_as_client():
	print("Starting client")
	var i = main_scene.instance()
	get_tree().root.call_deferred("add_child", i)
