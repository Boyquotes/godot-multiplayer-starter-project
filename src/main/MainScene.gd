extends Node

var default_server = true
var main_scene : PackedScene = load("res://src/ui/MainMenu.tscn")

func _ready():
	var args = OS.get_cmdline_args()
	
	if OS.has_feature("Server") or "--server" in args:
		start_as_server()
	elif "--client" in args :
		start_as_client()
	else:
		if default_server: start_as_server()
		else: start_as_client()

func start_as_server():
	print("Starting dedicated server")
	get_tree().root.get_child(0).queue_free()
	Server.create_server()

func start_as_client():
	print("Starting client")
	var i = main_scene.instance()
	get_tree().root.call_deferred("add_child", i)
	queue_free()

