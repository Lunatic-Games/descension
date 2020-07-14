extends Node2D


func _ready():
	randomize()
	$Particles2D.process_material = $Particles2D.process_material.duplicate()
	$BubblingAnimator.advance(rand_range(0, 
		$BubblingAnimator.current_animation_length))


func _on_border_area_entered(area, extra_arg_0):
	if !area.is_in_group("lava_border"):
		return
	match extra_arg_0:
		"north_east":
			$Borders/NorthEast.visible = false
		"east":
			$Borders/East.visible = false
			$Borders/NorthEast/ExtraBorder.visible = true
		"west":
			$Borders/West.visible = false
			$Borders/NorthWest/ExtraBorder.visible = true
		"north_west":
			$Borders/NorthWest.visible = false
