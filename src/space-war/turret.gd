# turret.gd
extends Node3D

@export var fire_rate := 0.3
@export var bullet_scene : PackedScene
@export var rotation_speed := 3.0
@export var health := 50.0
@export var team := "turret"
@export var mouse_sensitivity := 0.003
@export var pitch_limit := 89.0
var yaw := 0.0
var pitch := 0.0

var fire_timer := 0.0

func ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _physics_process(delta):
	fire_timer -= delta
	rotation.x = pitch
	rotation.y = yaw

	if Input.is_action_pressed("ui_accept") or Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
		_try_shoot()

func _input(event):
	if event is InputEventMouseMotion:
		yaw -= event.relative.x * mouse_sensitivity
		pitch -= event.relative.y * mouse_sensitivity
		pitch = clamp(pitch, deg_to_rad(-pitch_limit), deg_to_rad(pitch_limit))

	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_ESCAPE:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _try_shoot():
	if fire_timer <= 0.0:
		fire_timer = fire_rate
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		bullet.global_transform = $GunPoint.global_transform
		bullet.set_speed(400)
		bullet.owner_team = team
