extends Node2D
class_name Tile


signal hovered
signal pressed

export (bool) var HOVERABLE: bool

var id: int
var next_path_tile: Tile
var path_origin_tile: Tile


func begin_path_popup():
	stop_path_animation()
	$PathCircle/AnimationPlayer.play("first_path_popup")


func continue_path_popup():
	stop_path_animation()
	$PathCircle/AnimationPlayer.play("path_popup")


func restart_path_popup():
	stop_path_animation()
	$PathCircle/AnimationPlayer.play("restart_path_popup")


func stop_path_animation():
	$PathCircle/AnimationPlayer.stop()


func next_path_popup():
	if next_path_tile:
		next_path_tile.continue_path_popup()
	else:
		path_origin_tile.restart_path_popup()


func set_disabled_texture(revert: bool):
	if revert:
		$Button.texture_disabled = null
	else:
		$Button.texture_disabled = $Button.texture_pressed


func _on_Button_mouse_entered():
	emit_signal("hovered", self)


func unreachable():
	$Button.modulate = Color(1, 0, 0)


func reachable():
	$Button.modulate = Color(1, 1, 1)


func _on_Button_pressed():
	emit_signal("pressed", self)
