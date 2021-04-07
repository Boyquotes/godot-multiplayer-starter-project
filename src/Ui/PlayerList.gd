# This script is used in World scene
extends Control

func _ready():
	Client.connect("player_list_updated", self, "_on_player_list_updated")
	$LocalPlayer.text = Client.player_info.name


func _input(event):
	if event.is_action_pressed("toggle_player_list"):
		visible = !visible


func _on_player_list_updated():
	
	for child in $RemotePlayerList.get_children():
		child.queue_free()
		
	print(Client.players)
	
	for a in Client.players.keys():
		print(a)
		if a == Client.player_info.net_id: continue
		
		var l = Label.new()
		l.text = String(a) + " - " + Client.players[a].name
		$RemotePlayerList.add_child(l)
