extends Node2D


func _ready():
	randomize()
	$Particles2D.process_material = $Particles2D.process_material.duplicate()
	$BubblingAnimator.advance(rand_range(0, 
		$BubblingAnimator.current_animation_length))
