# PlayerController controls this node client-side and its puppet on the other clients
# You can create a PlayerController script server-side for doing server checks or server logic
extends KinematicBody2D

export var speed = 300


puppet var puppet_velocity = Vector2.ZERO
puppet var p_position

var velocity = Vector2.ZERO


func _process(delta):
	if is_network_master(): _master_process(delta)
	else: _puppet_process(delta)
	
	# We don't care how the velocity is obtained
	velocity = move_and_slide(velocity, Vector2.ZERO)


func _master_process(delta):
	# Get player input
	var x_mov = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var y_mov = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	# Calculate velocity
	velocity = Vector2(x_mov, y_mov).normalized() * speed
	
	# Update velocity remotely
	Client.rset_client(self, "puppet_velocity", velocity)
	Client.rset_client(self, "p_position", global_position)


func _puppet_process(delta):
	velocity = puppet_velocity
	if p_position:
		global_position = p_position
		p_position = null


func set_dominant_color(color):
	$Sprite.modulate = color
