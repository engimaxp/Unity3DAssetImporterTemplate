extends CharacterBody3D

var current_move_speed = 0.0

var SPEED = 15.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var is_in_enter_mode = false
var track_entity = null

func _unhandled_input(event):
	if Input.is_action_just_pressed("camera_speed_down"):
		SPEED -= 10.0
	elif Input.is_action_just_pressed("camera_speed_up"):
		SPEED += 10.0
	SPEED = clamp(SPEED,15.0,SPEED)
#
#func _ready():
	#Signals.enter_mode_trigger_by.connect(enter_mode_triggered)
	#Signals.exit_enter_mode.connect(exit_enter_mode)

func enter_mode_triggered(unit):
	is_in_enter_mode = true
	track_entity = unit

func exit_enter_mode(unit):
	if track_entity == unit:
		is_in_enter_mode = false
		track_entity = null

func _process(delta):
	if is_in_enter_mode:
		self.global_position.z = track_entity.global_position.z
		self.global_position.x = track_entity.global_position.x

func _physics_process(delta):
	if is_in_enter_mode:
		return
#	# Add the gravity.
#	if not is_on_floor():
#		velocity.y -= gravity * delta
#
#	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("a", "d", "w", "s")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	var y_input := Input.get_axis("dive","rise")
	var h_rot = get_tree().get_nodes_in_group("CameraController")[0].global_transform.basis.get_euler().y
	direction = direction.rotated(Vector3.UP,h_rot).normalized()
	
	current_move_speed = lerp(current_move_speed,SPEED,delta)
	if direction or y_input:
		velocity.x = direction.x * current_move_speed
		velocity.z = direction.z * current_move_speed
		velocity.y = y_input * current_move_speed
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		velocity.y = move_toward(velocity.y, 0, SPEED)

	move_and_slide()
