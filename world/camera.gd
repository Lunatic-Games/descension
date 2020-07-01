extends Camera2D


const PAN_SPEED = 250
const PAN_V_MARGIN = 75
const PAN_H_MARGIN = 100
const ZOOM_LEVELS = [0.5, 1]

var zoom_index: int = 1


# Set zoom level to default
func _ready():
	update_zoom_level()


# Handle pan and zoom inputs
func _input(event: InputEvent):
	if event is InputEventMouseMotion:
		print("Global: ", event.global_position)
	
	if event.is_action_pressed("camera_zoom_in"):
		zoom_index -= 1
		zoom_index = max(zoom_index, 0) as int
		update_zoom_level()
	elif event.is_action_pressed("camera_zoom_out"):
		zoom_index += 1
		zoom_index = min(zoom_index, len(ZOOM_LEVELS) - 1) as int
		update_zoom_level()


# Move when mouse is on screen edge or keyboard input
func _physics_process(delta: float):
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	var view_size: Vector2 = get_viewport_rect().size
	
	var movement := Vector2(0, 0)
	if Input.is_action_pressed("camera_up") or mouse_pos.y < PAN_V_MARGIN:
		movement.y -= 1
	if (Input.is_action_pressed("camera_right") 
			or mouse_pos.x > view_size.x - PAN_H_MARGIN):
		movement.x += 1
	if (Input.is_action_pressed("camera_down") 
			or mouse_pos.y > view_size.y - PAN_V_MARGIN):
		movement.y += 1
	if Input.is_action_pressed("camera_left") or mouse_pos.x < PAN_H_MARGIN:
		movement.x -= 1
	movement *= PAN_SPEED * delta
	position.x = (position.x + movement.x)
	position.y = (position.y + movement.y)
	
	var mouse_update = InputEventMouseMotion.new()
	mouse_update.device = 0
	var diff = (OS.window_size - Vector2(1024, 576)) / 2
	mouse_update.position = get_viewport().get_mouse_position() + diff
	get_tree().input_event(mouse_update)
	


# Update zoom x and y to be ZOOM_LEVELS[zoom_index]
func update_zoom_level():
	zoom.x = ZOOM_LEVELS[zoom_index]
	zoom.y = ZOOM_LEVELS[zoom_index]
