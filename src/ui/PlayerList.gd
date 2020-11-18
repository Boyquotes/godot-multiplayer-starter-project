extends Control

func _ready():
	Client.connect("player_list_updated", self, "_on_player_list_updated")
	$LocalPlayer.text = Client.player_info.name


func _on_player_list_updated():
	for child in $RemotePlayerList.get_children():
		child.queue_free()
	
	for id in Client.players:
		if id == Client.player_info.net_id: return
		
		var l = Label.new()
		l.text = String(id) + " - " + Client.players[id].name
		$RemotePlayerList.add_child(l)
