extends Spatial

var is_ball_cam = false
# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var def_camera
var def_trans = global_transform.basis
var def_trans_pos = Vector3.ZERO
var def_self
var free_cam = false
# Called when the node enters the scene tree for the first time.
func _ready():
	print("ready")
	def_camera = $Camera.transform
	def_trans_pos = $Camera.transform.origin
	def_self = transform

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_ball_cam:
		look_at(get_parent().get_parent().get_parent().get_parent().get_node("ball/RigidBody").global_transform.origin,Vector3.UP)
		rotate(Vector3(0,1,0),PI/2)
	#	global_transform.basis = def_trans
	else:
	#	global_transform.basis = def_trans
	#	$Camera.transform.origin = def_trans_pos
	#	$"Camera".transform = def_camera
		if !free_cam:
			transform = def_self
		else:
			global_transform.basis = def_trans
