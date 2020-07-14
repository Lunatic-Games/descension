extends Node2D


signal reached_destination

const PATH_MOVE_SPEED = 150

var standing_tile: Tile
var facing_direction := "south_east"
var current_animation: AnimationPlayer
var move_path := []


func _physics_process(delta):
	if !move_path:
		return
	
	var tile_pos: Vector2 = move_path.front().global_position + Vector2(0, 42)
	var towards = tile_pos - global_position
	if towards.length() < PATH_MOVE_SPEED * delta:
		global_position = tile_pos
		var popped: Tile = move_path.pop_front()
		popped.get_node("PathCircle").visible = false
		if !move_path:
			change_animation("Idle")
			standing_tile = popped
			get_tree().set_group("tile_button", "disabled", false)
			popped.set_disabled_texture(true)
			emit_signal("reached_destination")
		else:
			update_path_direction(move_path.front())
	else:
		position += towards.normalized() * PATH_MOVE_SPEED * delta


func setup(start_tile: Tile):
	global_position = start_tile.global_position + Vector2(0, 42)
	standing_tile = start_tile
	change_animation("Idle")


func update_path_direction(next_tile: Tile):
	var tile_center = next_tile.global_position + Vector2(0, 42)
	if tile_center.x > global_position.x and tile_center.y > global_position.y:
		change_direction("south_east")
	elif tile_center.x > global_position.x and tile_center.y < global_position.y:
		change_direction("north_east")
	elif tile_center.x > global_position.x:
		change_direction("east")
	elif tile_center.x < global_position.x and tile_center.y > global_position.y:
		change_direction("south_west")
	elif tile_center.x < global_position.x and tile_center.y < global_position.y:
		change_direction("north_west")
	elif tile_center.x < global_position.x:
		change_direction("west")


func change_animation(name: String):
	assert($Animations.has_node(name))
	if current_animation:
		current_animation.stop()
	current_animation = $Animations.get_node(name)
	change_direction(facing_direction)


func change_direction(direction: String):
	assert(current_animation.has_animation(direction))
	facing_direction = direction
	var current_pos = 0
	if current_animation.is_playing():
		current_pos = current_animation.current_animation_position
	current_animation.play(direction)
	current_animation.seek(current_pos, true)


func follow_path(tiles: Array):
	standing_tile = null
	move_path = tiles
	change_animation("Running")
	
