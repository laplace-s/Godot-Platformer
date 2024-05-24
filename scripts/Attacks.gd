extends Area2D
var detecting = false

func _process(delta):
	if(detecting):
		if(!get_overlapping_areas().is_empty()):
			get_overlapping_areas()[0].get_parent().die()
