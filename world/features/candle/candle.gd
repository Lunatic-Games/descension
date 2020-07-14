extends Node2D


func _ready():
	randomize()
	$AnimationPlayer.advance(rand_range(0, 
		$AnimationPlayer.current_animation_length))
