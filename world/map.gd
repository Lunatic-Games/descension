extends YSort


var astar := AStar2D.new()
var tiles := {}  # Dictionary with tile_id : tile
onready var player_tile := $GroundTiles/BaseTile24


# Setup astar and signals
func _ready():
	add_tiles_to_astar()
	connect_astar_nodes()
	
	for tile in $GroundTiles.get_children():
		tile.connect("hovered", self, "show_path")


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
func show_path(tile_to):
	var path: Array = astar.get_id_path(player_tile.id, tile_to.id)
	var all_tile_ids: Array = tiles.keys()
	
	path.pop_front()
	for i in all_tile_ids.size():
		var id: int = all_tile_ids[i]
		var tile: Tile = tiles[id]
		if path:
			tile.path_origin_tile = tiles[path[0]]
		tile.get_node("AnimationPlayer").stop()
		if path.has(id):
			tile.get_node("WalkCircle").visible = true
			tile.get_node("WalkCircle").scale = Vector2(0.5, 0.5)
			if id == path[0]:
				tile.begin_path_popup()
			if id == path[-1]:
				tile.next_path_tile = null
			else:
				tile.next_path_tile = tiles[path[path.find(id) + 1]]
		else:
			tile.next_path_tile = null
			tile.get_node("WalkCircle").scale = Vector2(0.5, 0.5)
			tile.get_node("WalkCircle").visible = false
