# bullet.gd
extends Area3D

var speed := 200.0
var damage := 10.0
var owner_team := ""

func _physics_process(delta):
	position += -transform.basis.z * speed * delta

func _on_body_entered(body):
	if body.has_method("take_damage") and body.team != owner_team:
		body.take_damage(damage)
		queue_free()

func set_color(color: Color):
	color = color
	var mat = $MeshInstance3D.get_surface_override_material(0)
	if mat == null:
		mat = StandardMaterial3D.new()
		$MeshInstance3D.set_surface_override_material(0, mat)
	mat.albedo_color = color
