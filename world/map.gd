extends YSort


var astar := AStar2D.new()
var tiles := {}  # Dictionary with tile_id : tile
var queued_tile_hover: Tile  # For hovers while player is travelling
var disable_physics = false
onready var player := $Brawler


# Setup astar, signals and player
func _ready():
	add_tiles_to_astar()
	connect_astar_nodes()
	
	for tile in $GroundTiles.get_children():
		tile.connect("hovered", self, "show_path")
		tile.connect("pressed", self, "follow_path")
	
	# warning-ignore:return_value_discarded
	player.connect("reached_destination", self, "player_done_move")
	player.setup($GroundTiles/BaseTile5)
	var _err = get_tree().connect("physics_frame", self, "disable_startup_physics")


func disable_startup_physics():
	yield(get_tree(), "physics_frame")
	get_tree().set_group("startup_physics", "disabled", true)


# Check if a queued path needs to be displayed
func player_done_move():
	if queued_tile_hover:
		show_path(queued_tile_hover)
		queued_tile_hover = null


# Add all children of GroundTiles to the astar graph
func add_tiles_to_astar():
	for tile in $GroundTiles.get_children():
		var id: int = astar.get_available_point_id()
		astar.add_point(id, tile.position)
		tile.id = id
		tiles[id] = tile


# Connect adjacent tiles in the astar graph
func connect_astar_nodes():
	for point in astar.get_points():
		var pos: Vector2 = astar.get_point_position(point)
		
		# Only need to do half of the directions, as the bidirectional connecting
		#   causes the other half to be connected from other tiles
		var adjacent_points := [astar.get_closest_point(pos + Vector2(64, 0)),
			astar.get_closest_point(pos + Vector2(32, -48)),
			astar.get_closest_point(pos + Vector2(-32, -48))]
		
		for adj_point in adjacent_points:
			if adj_point == -1 or adj_point == point:
				continue
			
			# Valid distances are either 57.x or 64.x
			var dist: float = (astar.get_point_position(adj_point) - pos).length()
			if dist > 50.0 and dist < 70.0:
				astar.connect_points(point, adj_point)


# Show a path from player tile to given tile
func show_path(tile_to: Tile):
	if !player.standing_tile:
		queued_tile_hover = tile_to
		return
	
	var path: Array = astar.get_id_path(player.standing_tile.id, tile_to.id)
	if path and path.size() > 1:
		tile_to.reachable()
		player.update_path_direction(tiles[path[1]])
	else:
		tile_to.unreachable()
		
	var all_tile_ids: Array = tiles.keys()
	
	path.pop_front()
	for i in all_tile_ids.size():
		var id: int = all_tile_ids[i]
		var tile: Tile = tiles[id]
		tile.stop_path_animation()
		if path.has(id):
			tile.path_origin_tile = tiles[path[0]]
			tile.get_node("PathCircle").visible = true
			tile.get_node("PathCircle").scale = Vector2(0.5, 0.5)
			if id == path[0]:
				tile.begin_path_popup()
			if id == path[-1]:
				tile.next_path_tile = null
			else:
				tile.next_path_tile = tiles[path[path.find(id) + 1]]
		else:
			tile.next_path_tile = null
			tile.get_node("PathCircle").scale = Vector2(0.5, 0.5)
			tile.get_node("PathCircle").visible = false


func follow_path(tile_to: Tile):
	if !player.standing_tile:
		return
	
	var path: Array = astar.get_id_path(player.standing_tile.id, tile_to.id)
	if !path or path.size() <= 1:
		return
	get_tree().set_group("tile_button", "disabled", true)
	tile_to.set_disabled_texture(false)
	var tile_path := []
	for id in path:
		tile_path.append(tiles[id])
	player.follow_path(tile_path)
