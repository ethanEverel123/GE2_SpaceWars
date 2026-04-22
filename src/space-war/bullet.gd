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
