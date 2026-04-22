extends CharacterBody3D

@export var team := "A"
@export var speed := 20.0
@export var turn_speed := 2.0
@export var health := 100.0
@export var fire_rate := 0.3
@export var bullet_scene : PackedScene
@export var max_distance_from_camera := 50.0


var camera : Camera3D

var target: Node3D = null
var fire_timer := 1.0

enum State { PATROL, PURSUE, ATTACK, EVADE }
var state := State.PATROL

func _ready():
	
	camera = get_tree().get_first_node_in_group("camera")

func _physics_process(delta):
	fire_timer -= delta
	_enforce_boundary(delta)
	_update_target()
	_update_state()

	match state:
		State.PATROL:  _patrol(delta)
		State.PURSUE:  _pursue(delta)
		State.ATTACK:  _attack(delta)
		State.EVADE:   _evade(delta)

	move_and_slide()

func _update_target():
	# Find nearest enemy in perception area
	var nearest_dist = INF
	for body in $Area3D.get_overlapping_bodies():
		if body.is_in_group("fighter") and body.team != team:
			var d = global_position.distance_to(body.global_position)
			if d < nearest_dist:
				nearest_dist = d
				target = body

func _update_state():
	if target == null:
		state = State.PATROL
	elif health < 30: #work on this
		state = State.EVADE
	elif global_position.distance_to(target.global_position) < 30:
		state = State.ATTACK
	else:
		state = State.PURSUE

func _patrol(delta):
	# fly forward
	velocity = -transform.basis.z * speed

func _pursue(delta):
	if not target: return
	var dir = (target.global_position - global_position).normalized()
	_steer_toward(dir, delta)
	velocity = -transform.basis.z * speed

func _attack(delta):
	if not target: return
	var dir = (target.global_position - global_position).normalized()
	_steer_toward(dir, delta)
	velocity = -transform.basis.z * speed
	_try_shoot()

func _evade(delta):
	if not target: return
	var dir = (global_position - target.global_position).normalized()
	_steer_toward(dir, delta)
	velocity = -transform.basis.z * speed * 1.5  # flee faster

func _steer_toward(direction: Vector3, delta: float):
	var target_transform = transform.looking_at(global_position + direction, Vector3.UP)
	transform = transform.interpolate_with(target_transform, turn_speed * delta)

func _try_shoot():
	if fire_timer <= 0.0:
		fire_timer = fire_rate
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		bullet.global_transform = $GunPoint.global_transform
		bullet.owner_team = team

func take_damage(amount: float):
	queue_free()

func _enforce_boundary(delta):
	if camera == null:
		return
	
	var dist = global_position.distance_to(camera.global_position)
	if dist > max_distance_from_camera:
		var direction = (camera.global_position - global_position).normalized()
		velocity = direction * speed * 2.0  
		
		#rotate
		var target_transform = transform.looking_at(camera.global_position, Vector3.UP)
		transform = transform.interpolate_with(target_transform, turn_speed * delta * 3.0)
		
		move_and_slide()
		return

func set_color(color: Color):
	var mat = $MeshInstance3D.get_surface_override_material(0)
	if mat == null:
		mat = StandardMaterial3D.new()
		$MeshInstance3D.set_surface_override_material(0, mat)
	mat.albedo_color = color
