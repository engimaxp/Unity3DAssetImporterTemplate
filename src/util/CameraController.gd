extends Node3D

@export var player_node_path:NodePath
@onready var player = get_node_or_null(player_node_path)

@export var  sensitivity:float = 4.5
@export var  scroll_sensitivity:float = 4.5
@export var away_camera_distance:float = 50.0
@export var close_camera_distance:float = 2.0

@onready var camera = $SpringArm3D/Camera3D
@onready var spring_arm_3d = $SpringArm3D

var is_start_rotation = false

# Called when the node enters the scene tree for the first time.
func _ready():
	print(player)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if is_instance_valid(player):
		global_position = player.global_position
		

func _unhandled_input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_MIDDLE:
		is_start_rotation = event.is_pressed()
		if is_start_rotation:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		else:
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			
	if event is InputEventMouseMotion and is_start_rotation:
		rotation = Vector3(clamp(rotation.x - event.relative.y / 1000 * sensitivity,-1,0.25),\
			rotation.y - event.relative.x / 1000 * sensitivity,0.0)
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_UP:
		spring_arm_3d.spring_length = clamp(spring_arm_3d.spring_length - 0.1 * scroll_sensitivity,close_camera_distance,away_camera_distance)
#		camera.position = Vector3(0,0,clamp(camera.position.z - 0.1,close_camera_distance,away_camera_distance))
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
#		camera.position = Vector3(0,0,clamp(camera.position.z + 0.1,close_camera_distance,away_camera_distance))
		spring_arm_3d.spring_length = clamp(spring_arm_3d.spring_length + 0.1 * scroll_sensitivity,close_camera_distance,away_camera_distance)
	
