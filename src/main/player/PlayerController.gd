extends KinematicBody2D

export var speed = 300

var velocity = Vector2.ZERO


func _process(delta):
	var x_mov = int(Input.is_action_pressed("ui_right")) - int(Input.is_action_pressed("ui_left"))
	var y_mov = int(Input.is_action_pressed("ui_down")) - int(Input.is_action_pressed("ui_up"))
	
	velocity = Vector2(x_mov, y_mov).normalized() * speed
	
	velocity = move_and_slide(velocity, Vector2.ZERO)


func set_dominant_color(color):
	$Sprite.modulate = color
