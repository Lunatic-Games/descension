extends Node2D


const MIN_ALPHA := 0.12
const MOUSE_ALPHA_DIST := 300.0
const SCREEN_EDGE_ALPHA_DIST := 100.0

var obstructs := false


# Check if alpha needs to be updated
func _physics_process(_delta):
	if obstructs:
		set_obstruction_alpha()
	else:
		modulate.a = 1.0


# Check if obstructing something in group 'visible_area'
func _on_ObstructionArea_area_entered(area: Area2D):
	if area.is_in_group("visible_area"):
		$ObstructionArea/CollisionPolygon2D.set_deferred("disabled", true)
		obstructs = true


# Set alpha based off how close to the edge of the screen or the mouse cursor
func set_obstruction_alpha():
	var screen_pos: Vector2 = $ObscurePosition.get_global_transform_with_canvas().origin
	var screen_size: Vector2 = get_viewport_rect().size
	var mouse_dist = (get_viewport().get_mouse_position() - screen_pos).length()
	var distances = [screen_pos.x, screen_size.x - screen_pos.x,
		screen_pos.y, screen_size.y - screen_pos.y]
	distances.sort()
	
	if distances[0] < SCREEN_EDGE_ALPHA_DIST and mouse_dist > MOUSE_ALPHA_DIST:
		modulate.a = 1.0
	else:
		var screen_edge_ratio = (distances[0] - SCREEN_EDGE_ALPHA_DIST) / 150.0
		screen_edge_ratio = max(1 - screen_edge_ratio, MIN_ALPHA)
		var mouse_ratio = max(pow(mouse_dist / MOUSE_ALPHA_DIST, 2), MIN_ALPHA)
		modulate.a = min(screen_edge_ratio, mouse_ratio)
