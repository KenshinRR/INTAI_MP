extends Line2D

var length = 20
var point = Vector2()

func _process(_delta):
	global_position = Vector2(0,0) #set to (0,0) to prevent any changes to the position of the trail
	global_rotation = 0 #set to 0 so no rotation will be applied
	
	point = get_parent().global_position #to follow the object
	
	add_point(point)
	
	while get_point_count() > length:
		remove_point(0)

