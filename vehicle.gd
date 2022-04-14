extends VehicleBody


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
const steering_const = 0.22 * 60
const engine_const = 70 * 60
var ball_cam = false
var def_camera
var global_def_camera
var jump_bool = false
var composite = Vector3.ZERO
var self_composite = Vector3.ZERO
var dodged = false
var t_rotation = 0
var anim
var cam_mode = 1
var alternator = false
var air_forward = false
var midair_move = false
var air_steering
#const air_steering_const
var copy_global_transfrom = global_transform
# Called when the node enters the scene tree for the first time.
func _ready():
	copy_global_transfrom = $"player-model/ball_cam_trans/Camera".global_transform
	def_camera = $"player-model/ball_cam_trans/Camera".transform
	global_def_camera = $"player-model/ball_cam_trans/Camera".global_transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_on_floor() && midair_move:
		midair_move = false
		$"player-model/ball_cam_trans".lerping = true
		$"player-model/ball_cam_trans".t_lerp = 0
	if is_on_floor() && !Input.is_action_pressed("jump"):
		jump_bool = false
		dodged = false
	steering = Input.get_axis("right","left") * steering_const * delta
	engine_force = Input.get_axis("back","forward") * engine_const * delta
	air_steering = Input.get_axis("air_rotate_left","air_rotate_right") * delta * 60
	if Input.get_axis("back","forward") < -0.5:
		engine_force *= 2.5 
	#print("data: ",jump_bool,dodged,Input.is_action_just_pressed("jump"),Input.is_action_pressed("forward"), " so final decision weather to dodge is: ",Input.is_action_just_pressed("jump") && jump_bool == true&& Input.is_action_pressed("forward") && !dodged)
	
	if Input.is_action_just_pressed("jump") && jump_bool == true&& Input.is_action_pressed("forward") && !dodged:
		#rotate animation
		jump_bool = true
		dodged = true
		apply_central_impulse(global_transform.basis.x * 300)
		print("dodged!!@")
		air_forward = false
		#apply_torque_impulse(-global_transform.basis.z * 130)
	if Input.is_action_just_pressed("jump") && is_on_floor() && !jump_bool:
		print("jumped")
		jump_bool = true
		air_forward = false
		apply_central_impulse(Vector3.UP * 250)
	
	if Input.is_action_pressed("left") && !is_on_floor():
		apply_torque_impulse(global_transform.basis.y * 0.7)
		midair_move = true
	if Input.is_action_pressed("right") && !is_on_floor():
		apply_torque_impulse(-global_transform.basis.y * 0.7)
		midair_move = true
	if Input.is_action_pressed("back") && !is_on_floor():
		apply_torque_impulse(global_transform.basis.z * 0.4)
		midair_move = true
	if Input.is_action_just_pressed("forward") && !is_on_floor():
		air_forward = true
		midair_move = true
	if Input.is_action_pressed("forward") && !is_on_floor() && air_forward:
		apply_torque_impulse(-global_transform.basis.z * 0.4)
		midair_move = true
	if air_steering != 0 && !is_on_floor():
		apply_torque_impulse(global_transform.basis.x * air_steering * 0.4)
		midair_move = true
	if (Input.is_action_just_pressed("air_rotate_left") || Input.is_action_just_pressed("air_rotate_right") || Input.is_action_just_pressed("forward") || Input.is_action_just_pressed("back") || Input.is_action_just_pressed("right") || Input.is_action_just_pressed("left")) && midair_move:
		$"player-model/ball_cam_trans".def_trans = $"player-model/ball_cam_trans".global_transform.basis
	if Input.is_action_just_pressed("change_cam"):
		cam_mode = (cam_mode + 1) % 3
	if cam_mode == 0:
		#composite = get_parent().get_parent().get_node("ball/RigidBody").global_transform.origin
		#print(composite)
		#composite.y = global_transform.origin.y
		#self_composite = global_transform.origin
		#self_composite.y = $"player-model/ball_cam_trans/Camera".global_transform.origin.y 
		#self_composite.x = $"player-model/ball_cam_trans/Camera".global_transform.origin.x
	#	$"player-model/Camera".look_at_from_position(self_composite,composite,Vector3.UP)
		#$"player-model/ball_cam_trans/Camera".look_at(composite,Vector3.UP)
		#$"player-model/Camera".global_transform.origin = self_composite
		$Label.visible = true
		$"player-model/ball_cam_trans".is_ball_cam = true
		#$TextureRect.visible = true
	elif cam_mode == 1 && midair_move == false:
		#$"player-model/ball_cam_trans/Camera".transform = def_camera
		$Label.visible = false
		$TextureRect.visible = false
		$"player-model/ball_cam_trans".free_cam = false
		$"player-model/ball_cam_trans".is_ball_cam = false
	else:
		$Label.visible = false
		$TextureRect.visible = false
		$"player-model/ball_cam_trans".is_ball_cam = false
		$"player-model/ball_cam_trans".free_cam = true
	alternator = !alternator
func _on_Timer_timeout():
	$TextureRect.visible = !$TextureRect.visible

func is_on_floor():
	return $back_left_wheel.is_in_contact() || $back_right_wheel.is_in_contact() || $front_right_wheel.is_in_contact() || $front_left_wheel.is_in_contact()
