extends Node2D

onready var polygon: Polygon2D = get_node("Polygon2D")

export var INTERVAL_SPAWN: float = 0.5  
export var MAX_BOLT: int = 5
export var MIN_BOLT: int = 1

# export the Eclair data here so we can access it from each EclairSpawner
export var max_branches: int = 5
export(float, 0.0, 1) var max_branches_randomness: float = 0.5
export var max_branch_lenght: float = 30
export var min_branch_lenght: float = 10
export var lifetime: float = 0.2
export(float, 0.0, 1) var lifetime_randomness: float = 0.0
export var width: float = 2

export var base_angle: float = 0.0
export var light_power: float = 1.5

export var active: bool = true




var rng = RandomNumberGenerator.new()
var last_points = []

func _ready():
	rng.randomize()
	print(polygon.polygon)
	point_in_polygon()
	$Timer.connect("timeout", self, "_onTimeout")
	$Timer.start(INTERVAL_SPAWN)

func spawn_eclair(pos):
	var eclair = preload("res://Eclair.tscn").instance()
	eclair.global_position = pos
	# print("spawn_eclair at " + str(pos))

	eclair.max_branches = max_branches
	eclair.max_branches_randomness = max_branches_randomness
	eclair.max_branch_lenght = max_branch_lenght
	eclair.lifetime = lifetime
	eclair.lifetime_randomness = lifetime_randomness
	eclair.width = width
	eclair.light_power = light_power
	eclair.base_angle = base_angle

	get_parent().add_child(eclair)


func _input(event):
	if event.is_action_pressed("custom"):
		spawn_eclair(get_global_mouse_position())

func _draw():
	for p in last_points:
		draw_circle(p, 1, Color.green)


# This technique is from https://observablehq.com/@scarysize/finding-random-points-in-a-polygon
func getTriangleArea(triangle):
	var a = triangle[0]
	var b = triangle[1]
	var c = triangle[2]

	return 0.5 * ((b[0] - a[0]) * (c[1] - a[1]) - (c[0] - a[0]) * (b[1] - a[1]))


func generateDistribution(triangles):
	var totalArea: float = 0.0
	for t in triangles:
		totalArea += getTriangleArea(t)
	var cumulativeDistribution = []

	for i in triangles.size():
		var lastValue: float = 0.0
		if i == 0:
			lastValue = 0.0
		else:
			lastValue = cumulativeDistribution[i - 1]

		var nextValue = lastValue + getTriangleArea(triangles[i]) / totalArea
		cumulativeDistribution.push_back(nextValue)
	return cumulativeDistribution



func calcRandomPoint(triangle):
	var wb = rng.randf();
	var wc = rng.randf();

	# point will be outside of the triangle, invert weights
	if (wb + wc > 1):
		wb = 1 - wb;
		wc = 1 - wc;
	
	var a = triangle[0]
	var b = triangle[1]
	var c = triangle[2]
	
	var rb_x = wb * (b.x - a.x);
	var rb_y = wb * (b.y - a.y);
	var rc_x = wc * (c.x - a.x);
	var rc_y = wc * (c.y - a.y);

	var r_x = rb_x + rc_x + a.x;
	var r_y = rb_y + rc_y + a.y;

	return [r_x, r_y]


func point_in_polygon():
	var triangles_pts = Geometry.triangulate_polygon(polygon.polygon)
	var triangles = []
	for i in triangles_pts.size()/3:
		var idx = i*3
		triangles.push_back([polygon.polygon[triangles_pts[idx]], 
		polygon.polygon[triangles_pts[idx+1]], 
		polygon.polygon[triangles_pts[idx+2]]])
	var dist = generateDistribution(triangles)

	var rnd = rng.randf();
	var idx: int = 0

	for i in dist.size():
		if dist[i] > rnd:
			idx = i
			break
	var point = calcRandomPoint(triangles[idx])
	point = Vector2(point[0], point[1])

	# Used to compensate if we move the polygon
	spawn_eclair(point+polygon.position)

func spawn_group():
	var nb_bolt = rng.randi_range(MIN_BOLT, MAX_BOLT)

	for i in nb_bolt:
		point_in_polygon()

func plot_points():
	update()
	# last_points.clear()

func _onTimeout():
	if active:
		spawn_group()
	#plot_points()
	
	
	var time = INTERVAL_SPAWN * (1 + rng.randf_range(-0.5, 0.5))
	$Timer.start(time)
