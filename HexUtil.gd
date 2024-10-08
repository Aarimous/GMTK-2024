extends Resource
class_name HexUtil

var neighbors_vectors = [Vector2(1,0), Vector2(1,-1), Vector2(0,-1), Vector2(-1,0), Vector2(-1,1), Vector2(0,1)] 
#var neighbors_of_neighbors_vectors = [Vector2(1,0), Vector2(1,-1), Vector2(0,-1), Vector2(-1,0), Vector2(-1,1), Vector2(0,1)] 

var cell_size : Vector2

var _sqrt_3 = sqrt(3.0)
var _sqrt_3_over_2 = _sqrt_3/2.0
var _sqrt_3_over_3 = _sqrt_3/3.0
var _3_over_2 = 3.0/2.0
var _2_over_3 = 2.0/3.0
var _neg_1_over_3 = -1.0/3.0

func _init(_cell_size : Vector2):
	self.cell_size = _cell_size


func cell_to_pointy_pixel(cell : Vector2):
	var x = ( _sqrt_3 * cell.x + _sqrt_3_over_2 * cell.y) * cell_size.x;
	var y = (_3_over_2 * cell.y) * cell_size.y
	return Vector2(x, y)

func cell_to_flat_pixel(cell : Vector2):	
	var x = ( _3_over_2 * cell.x) * cell_size.x;
	var y = (_sqrt_3_over_2 * cell.x + _sqrt_3 * cell.y) * cell_size.y
	return Vector2(x, y)
	
func pixel_to_cell(point : Vector2):
	point.x = point.x/cell_size.x 
	point.y = point.y/cell_size.y
	var q = _sqrt_3_over_3 * point.x + _neg_1_over_3 * point.y
	var r = 0.0 * point.x + _2_over_3 * point.y
	var hex_v3 = hex_round(Vector3(q,r,-q-r))
	return Vector2(hex_v3.x, hex_v3.y)
	
	
func cell_to_qrs(cell : Vector2) -> Vector3:
	return Vector3(cell.x, cell.y, -cell.x - cell.y)
	
func qrs_to_cell(qrs : Vector3) -> Vector2:
	return Vector2(qrs.x, qrs.y)
	
func rotate_hex_cell(cell : Vector2, steps = 1) -> Vector2:
	var qrs : Vector3 = cell_to_qrs(cell)
	for i in range(steps):
		if steps > 0:
			qrs = Vector3(-qrs.z, -qrs.x, -qrs.y)
		else:
			qrs = Vector3(-qrs.y, -qrs.z, -qrs.x)
			
	return qrs_to_cell(qrs)

	
func vec3PositionToCellVec3(vec3 : Vector3) -> Vector3:
	var cell = pixel_to_cell(Vector2(vec3.x, vec3.z))
	return Vector3(cell.x, vec3.y, cell.y)
	
	
func hex_round(h : Vector3) -> Vector3:
	var q = int(round(h.x))
	var r = int(round(h.y))
	var s = int(round(h.z))
	var q_diff = abs(q - h.x)
	var r_diff = abs(r - h.y)
	var s_diff = abs(s - h.z)
	if (q_diff > r_diff and q_diff > s_diff):
		q = -r - s
	elif (r_diff > s_diff):
		r = -q - s
	else:
		s = -q - r
	return Vector3(q, r, s)
	
	
func hex_cell_distance(a : Vector2, b : Vector2):
	var ac = cell_to_qrs(a)
	var bc = cell_to_qrs(b)
	return cube_distance(ac, bc)
	
func cube_subtract(a : Vector3, b : Vector3):
	return Vector3(a.x - b.x, a.y - b.y, a.z - b.z)
	
func cube_add(a : Vector3, b : Vector3):
	return Vector3(a.x + b.x, a.y + b.y, a.z + b.z)

func cube_distance(a : Vector3, b : Vector3):
	var vec : Vector3 = cube_subtract(a, b)
	return (abs(vec.x) + abs(vec.y) + abs(vec.z)) / 2.0
