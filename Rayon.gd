extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# # Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):
# 	beam_fire()
# 	pass
# func beam_fire(): # This is where I want most of the laser beam's code to be.

# 	$Line2D.global_position = Vector2.ZERO
# 	$Line2D.points[0] = Vector2.ZERO
	
	
# 	var Offset = get_global_mouse_position()
# 	var DistanceToMouse = Offset.length()
# 	var Rotation = Offset / DistanceToMouse #Optimal same as Offset.normalized()
	
# 	var LimitedLazer = 300
	
# 	# if DistanceToMouse > LimitedLazer:
# 	# 	$Line2D.points[1] = Rotation* LimitedLazer
# 	# else:
# 	# 	$Line2D.points[1] = Offset
# 	$Line2D.points[1] = Offset
	
# 	# $Line2D/RayCast2D.cast_to = $Line2D.points[1]
