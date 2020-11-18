extends Control

func _ready():
	Client.connect("join_success", self, "_on_ready_to_play")
	Client.connect("join_fail", self, "_on_join_fail")

func set_player_info():
	if !$Panel/NameInput.text.empty():
		Client.player_info.name = $Panel/NameInput.text
	else:
		Client.player_info.name += get_tree().get_network_unique_id()
	
	Client.player_info.char_color = $Panel/ColorPickerButton.color
	Client.player_info.net_id = get_tree().get_network_unique_id()


func _on_ready_to_play():
	get_tree().change_scene("res://src/main/World.tscn")
	queue_free()


func _on_join_fail():
	print("Failed to join server")


func _on_JoinBtn_pressed():
	Client.join_server("127.0.0.1", 1111)


func _on_color_changed(color):
	$Panel/TextureRect.self_modulate = color
