extends Node2D


export (bool) var HOVERABLE: bool


func _on_mouse_entered():
	if HOVERABLE:
		$HoverSprite.visible = true


func _on_mouse_exited():
	if HOVERABLE:
		$HoverSprite.visible = false
