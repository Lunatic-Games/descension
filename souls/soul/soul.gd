extends Node2D


signal reached_destination

const PATH_MOVE_SPEED = 150

var standing_tile: Tile
var facing_direction := "north_west"
var state: Node
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
			change_state("Idle")
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
	change_state("Idle")


func update_path_direction(next_tile: Tile):
	var tile_center = next_tile.global_position + Vector2(0, 42)
	if tile_center.x > global_position.x and tile_center.y > global_position.y:
		facing_direction = "south_east"
		state.get_node("AnimationPlayer").play(facing_direction)
	elif tile_center.x > global_position.x and tile_center.y < global_position.y:
		facing_direction = "north_east"
		state.get_node("AnimationPlayer").play(facing_direction)
	elif tile_center.x > global_position.x:
		facing_direction = "south_east"
		state.get_node("AnimationPlayer").play(facing_direction)
	elif tile_center.x < global_position.x and tile_center.y > global_position.y:
		facing_direction = "south_west"
		state.get_node("AnimationPlayer").play(facing_direction)
	elif tile_center.x < global_position.x and tile_center.y < global_position.y:
		facing_direction = "north_west"
		state.get_node("AnimationPlayer").play(facing_direction)
	elif tile_center.x < global_position.x:
		facing_direction = "south_west"
		state.get_node("AnimationPlayer").play(facing_direction)


func change_state(name: String):
	if state:
		state.get_node("AnimationPlayer").stop()
	assert(has_node(name))
	state = get_node(name)
	if !state.get_node("AnimationPlayer").has_animation(facing_direction):
		return
	state.get_node("AnimationPlayer").play(facing_direction)


func follow_path(tiles: Array):
	standing_tile = null
	move_path = tiles
	change_state("Moving")
	
