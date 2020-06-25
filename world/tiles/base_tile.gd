extends Node2D


export (bool) var HOVERABLE: bool


# Show hover sprite
func _on_mouse_entered():
	if HOVERABLE:
		$HoverSprite.visible = true


# Hide hover sprite
func _on_mouse_exited():
	if HOVERABLE:
		$HoverSprite.visible = false
