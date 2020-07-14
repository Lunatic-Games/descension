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
			$Borders/NorthEast/Sprite.visible = false
			$Borders/NorthEast/ExtraBorder.visible = false
			if $Borders/NorthWest/Sprite.visible:
				$Borders/NorthWest/ExtraBorder2.visible = true
			if $Borders/East/Sprite.visible:
				$Borders/East/ExtraBorder2.visible = true
		"north_west":
			$Borders/NorthWest/Sprite.visible = false
			$Borders/NorthWest/ExtraBorder.visible = false
			if $Borders/NorthEast/Sprite.visible:
				$Borders/NorthEast/ExtraBorder2.visible = true
			if $Borders/West/Sprite.visible:
				$Borders/West/ExtraBorder2.visible = true
		"east":
			$Borders/East/Sprite.visible = false
			$Borders/East/ExtraBorder.visible = false
			$Borders/East/ExtraBorder2.visible = false
			if $Borders/NorthEast/Sprite.visible:
				$Borders/NorthEast/ExtraBorder.visible = true
		"west":
			$Borders/West/Sprite.visible = false
			$Borders/West/ExtraBorder.visible = false
			$Borders/West/ExtraBorder2.visible = false
			if $Borders/NorthWest/Sprite.visible:
				$Borders/NorthWest/ExtraBorder.visible = true
		"south_east":
			if $Borders/East/Sprite.visible:
				$Borders/East/ExtraBorder.visible = true
		"south_west":
			if $Borders/West/Sprite.visible:
				$Borders/West/ExtraBorder.visible = true
		
