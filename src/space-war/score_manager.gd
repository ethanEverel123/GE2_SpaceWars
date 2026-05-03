# score_manager.gd
extends Node

# score_manager.gd
var scores := {
	"A": 0,
	"B": 0,
	"turret": 0
}


signal score_updated


func add_kill(killing_team: String):
	if scores.has(killing_team):
		scores[killing_team] += 1
		emit_signal("score_updated")
		# directly call the scoreboard as a fallback
		get_tree().get_first_node_in_group("scoreboard").update_display()

func reset():
	scores["A"] = 0
	scores["B"] = 0
	scores["turret"] = 0
	emit_signal("score_updated")
