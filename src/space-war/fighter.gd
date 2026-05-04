extends CharacterBody3D

@export var team := "A"
@export var speed := 30.0
@export var turn_speed := 2.0
@export var health := 100.0
@export var fire_rate := 0.3
@export var bullet_scene : PackedScene
@export var max_distance_from_camera := 50.0
@export var death_explosion : PackedScene
@export var avoid_distance := 5
@export var shoot_noise : PackedScene
@export var debris : PackedScene


var turret : Node3D
var target: Node3D = null
var fire_timer := 1.0
var color : Color
var avoid := [] #for avoiding friends




enum State { PATROL, PURSUE, ATTACK, EVADE }
var state := State.PATROL

func _ready():
	
	turret = get_tree().get_first_node_in_group("camera")
	$friendsphere.connect("body_entered", _on_friend_entered)
	$friendsphere.connect("body_exited", _on_friend_exited)

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
	elif health < 30: #update to if being fired at
		state = State.EVADE
	elif global_position.distance_to(target.global_position) < 20:
		state = State.ATTACK
	else:
		state = State.PURSUE

func _patrol(delta):
	# fly forward
	velocity = transform.basis.z * speed

func _pursue(delta):
	if not target: return
	
	var chase_dir = (target.global_position - global_position).normalized()
	var avoidance = _get_avoidance_force() #steering behaviour
	var final_dir = (chase_dir + avoidance).normalized()
	
	
	_steer_toward(final_dir, delta)
	velocity = -transform.basis.z * speed

func _attack(delta):
	if not target: return
	
	var chase_dir = (target.global_position - global_position).normalized()
	var avoidance = _get_avoidance_force()
	var final_dir = (chase_dir + avoidance).normalized()
	
	_steer_toward(final_dir, delta)
	velocity = -transform.basis.z * speed
	_try_shoot()

func _evade(delta):
	if not target: return
	var dir = (global_position - target.global_position).normalized()
	_steer_toward(dir, delta)
	velocity = -transform.basis.z * speed * 1.5  # flee faster

func _steer_toward(direction: Vector3, delta: float):
	var target_transform = transform.looking_at(global_position + direction, transform.basis.y)
	transform = transform.interpolate_with(target_transform, turn_speed * delta)

func _try_shoot():
	if fire_timer <= 0.0:
		fire_timer = fire_rate
		
		var bullet = bullet_scene.instantiate()
		var shoot_noise = shoot_noise.instantiate()
		
		get_tree().root.add_child(shoot_noise)
		get_tree().root.add_child(bullet)
		
		shoot_noise.global_position = global_position
		shoot_noise.emitting = true
		bullet.set_color(color)
		bullet.global_transform = $GunPoint.global_transform
		bullet.owner_team = team

func take_damage(amount: float, attacking_team : String):
	ScoreManager.add_kill(attacking_team)

	var explosion = death_explosion.instantiate()
	get_tree().root.add_child(explosion)
	explosion.global_position = global_position
	explosion.emitting = true
	
	#var debris = debris.instantiate()
	#get_tree().root.add_child(debris)
	#debris.global_position = global_position
	
	queue_free()

func _enforce_boundary(delta):
	if turret == null:
		return
	
	var dist = global_position.distance_to(turret.global_position)
	if dist > max_distance_from_camera:
		var direction = (turret.global_position - global_position).normalized()
		velocity = direction * speed * 2.0  
		
		#rotate
		var target_transform = transform.looking_at(turret.global_position, Vector3.UP)
		transform = transform.interpolate_with(target_transform, turn_speed * delta * 3.0)
		
		move_and_slide()
		return

func _on_friend_entered(body):
	if body.is_in_group("fighters") and body.team == team and body != self:
		avoid.append(body)
	elif body.is_in_group("debris"):
		avoid.append(body)
	
func _on_friend_exited(body):
	avoid.erase(body)

func _get_avoidance_force() -> Vector3:
	var force = Vector3.ZERO
	for friend in avoid:
		if not is_instance_valid(friend):
			continue
		var diff = global_position - friend.global_position
		var dist = diff.length()
		if dist > 0:
			force += diff.normalized() * (avoid_distance / dist) * 3
	return force
