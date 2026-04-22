# spawn_manager.gd
extends Node3D

@export var fighter_scene : PackedScene
@export var fighters_per_team := 3
@export var spawn_radius := 30.0

@export var TeamA : Node3D
@export var TeamB : Node3D


func _ready():
	_spawn_team("A", TeamA, Vector3(-20, 0, 0))
	_spawn_team("B", TeamB, Vector3(20, 0, 0))

func _spawn_team(team_name: String, container: Node3D, origin: Vector3):
	for i in fighters_per_team:
		var fighter = fighter_scene.instantiate()
		if container == TeamA:
			fighter.MeshInstance3D.mesh.material.albedo_color = 000000
		container.add_child(fighter)
		fighter.team = team_name
		fighter.add_to_group("fighter")
		fighter.global_position = origin + Vector3(
			randf_range(-spawn_radius, spawn_radius),
			randf_range(-5, 5),
			randf_range(-spawn_radius, spawn_radius)
		)
