extends Node2D

export var max_branches: int = 5
export(float, 0.0, 1) var max_branches_randomness: float = 0.5
export var max_branch_lenght: float = 30
export var min_branch_lenght: float = 10
export var lifetime: float = 0.5
export(float, 0.0, 1) var lifetime_randomness: float = 0.0
export var width: float = 2

var base_angle: float = 0.0
var light_power: float = 1.5

var light_power_scaled: float = 0.0


var rng = RandomNumberGenerator.new()
onready var tween: Tween = get_node("Tween")


func create_line():

	var line: Line2D = $Line2D
	var nb_branches: int = rng.randi_range(max_branches-max_branches*max_branches_randomness,max_branches)

	var point: Vector2 = Vector2.ZERO
	var last_point: Vector2 = Vector2.ZERO
	var tot_lenght: float = 0.0

	line.add_point(last_point)
	
	for i in nb_branches:
		var angle = rng.randf_range(0+deg2rad(base_angle), PI+deg2rad(base_angle))
		var lenght = rng.randf_range(min_branch_lenght, max_branch_lenght)
		tot_lenght += lenght
		
		point.x = lenght*cos(angle)
		point.y = lenght*sin(angle)
		
		point += last_point

		line.add_point(point)
		last_point = point


	# print("Eclair :" )
	# print("		Max branches: " + str(max_branches))
	# print("		Lifetime: " + str(lifetime))	
	# print("		tot_lenght: " + str(tot_lenght))	
	# print("		nb_branches: " + str(nb_branches))	

	var light_scale = tot_lenght / (max_branches*max_branch_lenght)
	$Light2D.scale = Vector2(light_scale, light_scale)* light_power
	light_power_scaled = 1.0 * light_scale
	$Line2D.width = width
		
func init_tween():
	var lifetime_rng: float = rng.randf_range(lifetime-lifetime*lifetime_randomness,lifetime)
	print(lifetime_rng)
	tween.interpolate_property($Light2D, "energy", light_power_scaled, 0.0, lifetime_rng, Tween.TRANS_SINE)
	tween.interpolate_property(self, "modulate", Color(1.0, 1.0, 1.0, 1.0), Color(1.0, 1.0, 1.0, 0.0), lifetime_rng, Tween.TRANS_SINE)

	tween.connect("tween_all_completed", self, "_onTweenCompleted")
	tween.start()

func _ready():
	rng.randomize()
	create_line()
	init_tween()



func _onTweenCompleted():
	queue_free();
