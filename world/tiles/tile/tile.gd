extends Node2D
class_name Tile


signal hovered
signal pressed

export (bool) var HOVERABLE: bool

var id: int
var next_path_tile: Tile
var path_origin_tile: Tile


func _on_mouse_entered():
	emit_signal("hovered", self)


func begin_path_popup():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("first_path_popup")


func continue_path_popup():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("path_popup")


func restart_path_popup():
	$AnimationPlayer.stop()
	$AnimationPlayer.play("restart_path_popup")


func next_path_popup():
	if next_path_tile:
		next_path_tile.continue_path_popup()
	else:
		path_origin_tile.restart_path_popup()


func unreachable():
	$Button.modulate = Color(1, 0, 0)


func reachable():
	$Button.modulate = Color(1, 1, 1)


func _on_pressed():
	emit_signal("pressed", self)
