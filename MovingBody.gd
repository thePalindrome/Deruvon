xtends KinematicBody

# Camera Control Variables
# Affects camera angle (when mouse is moved vertically)
const CAMERA_X_ROT_MIN = 0
const CAMERA_X_ROT_MAX = 30

# Affects mouse sensitivity for camera control
var sensitivity = 0.01

# Internal variables
var camera_x_rot = 0.0

# Movement Variables
var speed = 15
var jumpforce = 3
var forward
var back
var left
var right
var jump

# Movement Constants
const gravity = -9.8


func _ready():
	# Capture mouse within game
	Input.set_mouse_mode(2)
	set_process_input(true)


func _input(event):
	if event is InputEventMouseMotion:
		# Left and right camera movement
		$CameraBase.rotate_y(-event.relative.x * sensitivity)
		$CameraBase.orthonormalize()

		# Up and down camera movement
		camera_x_rot = clamp(
			camera_x_rot - event.relative.y * sensitivity,
			deg2rad(CAMERA_X_ROT_MIN),
			deg2rad(CAMERA_X_ROT_MAX))
		$CameraBase/CameraRotation.rotation.x =  camera_x_rot


func _physics_process(delta):
	
	var motion = Vector3()
	
	forward = Input.is_key_pressed(KEY_UP) || Input.is_key_pressed(KEY_W)
	
	back = Input.is_key_pressed(KEY_DOWN) || Input.is_key_pressed(KEY_S)
	
	left = Input.is_key_pressed(KEY_LEFT) || Input.is_key_pressed(KEY_A)
	
	right= Input.is_key_pressed(KEY_RIGHT) || Input.is_key_pressed(KEY_D)
	
	jump = Input.is_key_pressed(KEY_SPACE)
	
	if jump and on_floor():
		self.move_and_slide(Vector3(0,100,0))
		
	# Move forwards
	if forward:
		print("going forwards")
		motion.x = speed
		
	# Move left
	if left:
		print("going left")
		motion.z = -speed
	
	# Move right
	if right:
		print("going right")
		motion.z = speed
		
	# Move backwards
	if back:
		print("going back")
		motion.x = -speed
		
	# Gravity
	if !on_floor():
		motion.y += gravity + delta
	
	self.move_and_slide(motion)

func on_floor():
	return self.test_move(self.transform, Vector3(0,-1,0))
	print("On floor")
