# spawn_manager.gd
extends Node3D

@export var fighter_sceneR : PackedScene
@export var fighter_sceneB : PackedScene

@export var fighters_per_team := 8
@export var spawn_radius := 50.0

@export var TeamA : Node3D
@export var TeamB : Node3D

@export var team_a_color := Color.BLUE
@export var team_b_color := Color.RED


func _ready():
	_spawn_team("A", TeamA, Vector3(-20, 0, 0), team_a_color)
	_spawn_team("B", TeamB, Vector3(20, 0, 0), team_b_color)

func _spawn_team(team_name: String, container: Node3D, origin: Vector3, color: Color):
	for i in fighters_per_team:
		var fighter
		if color == Color.BLUE:
			fighter = fighter_sceneB.instantiate()
		if color == Color.RED:
			fighter = fighter_sceneR.instantiate()
		
		container.add_child(fighter)

		fighter.team = team_name
		fighter.add_to_group("fighter")
		fighter.global_position = origin + Vector3(
			randf_range(-spawn_radius, spawn_radius),
			randf_range(-5, 5),
			randf_range(-spawn_radius, spawn_radius)
		)
