extends KinematicBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var vel = Vector3.ZERO
const G = 9.8
const max_speed = 5
const x_accel = 0.3
const x_deccel = 0.2
const z_accel = 0.1
const max_z = 5
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("ui_up"):
		if vel.x < max_speed:
			vel.x += x_accel
		else:
			vel.x = max_speed
	else:
		if vel.x > x_deccel:
			vel.x -= x_deccel
	if Input.is_action_pressed("ui_down"):
		if vel.x > -max_speed:
			vel.x = vel.x - x_accel
		else:
			vel.x = -max_speed
	else:
		if vel.x < -x_deccel:
			vel.x += x_deccel
	if Input.is_action_pressed("ui_left"):
		if abs(vel.z) < max_z:
			vel.z -= z_accel
	print(vel)
	move_and_slide(vel,Vector3.UP)
	if !is_on_floor():
		vel.y -= G * delta
	else:
		vel.y = 0
