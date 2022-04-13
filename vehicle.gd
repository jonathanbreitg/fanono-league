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
var copy_global_transfrom = global_transform
# Called when the node enters the scene tree for the first time.
func _ready():
	copy_global_transfrom = $"player-model/Camera".global_transform
	def_camera = $"player-model/Camera".transform
	global_def_camera = $"player-model/Camera".global_transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_on_floor() && !Input.is_action_pressed("jump"):
		jump_bool = false
		dodged = false
	steering = Input.get_axis("right","left") * steering_const * delta
	engine_force = Input.get_axis("back","forward") * engine_const * delta
	if Input.get_axis("back","forward") < -0.5:
		engine_force *= 2.5 
	#print("data: ",jump_bool,dodged,Input.is_action_just_pressed("jump"),Input.is_action_pressed("forward"), " so final decision weather to dodge is: ",Input.is_action_just_pressed("jump") && jump_bool == true&& Input.is_action_pressed("forward") && !dodged)
	
	if Input.is_action_just_pressed("jump") && jump_bool == true&& Input.is_action_pressed("forward") && !dodged:
		#rotate animation
		jump_bool = true
		dodged = true
		apply_central_impulse(global_transform.basis.x * 300)
		print("dodged!!@")
		
	if Input.is_action_just_pressed("jump") && is_on_floor() && !jump_bool:
		print("jumped")
		jump_bool = true

		apply_central_impulse(Vector3.UP * 250)

	if Input.is_action_just_pressed("change_cam"):
		ball_cam = !ball_cam
	if ball_cam:
		composite = get_parent().get_parent().get_node("ball/RigidBody").global_transform.origin
		print(composite)
		composite.y = global_transform.origin.y
		self_composite = global_transform.origin
		self_composite.y = $"player-model/Camera".global_transform.origin.y 
		self_composite.x = $"player-model/Camera".global_transform.origin.x
		$"player-model/Camera".look_at_from_position(self_composite,composite,Vector3.UP)
		$Label.visible = true
		#$TextureRect.visible = true
	else:
		$"player-model/Camera".transform = def_camera
		$Label.visible = false
		$TextureRect.visible = false

func _on_Timer_timeout():
	$TextureRect.visible = !$TextureRect.visible

func is_on_floor():
	return $back_left_wheel.is_in_contact() || $back_right_wheel.is_in_contact() || $front_right_wheel.is_in_contact() || $front_left_wheel.is_in_contact()
