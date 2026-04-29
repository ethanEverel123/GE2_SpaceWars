# scoreboard.gd
extends Control

# scoreboard.gd
func _ready():
	add_to_group("scoreboard")
	update_display()

func update_display():
	$RedTeamLabel.text = "Team A: " + str(ScoreManager.scores["A"])
	$BlueTeamLabel.text = "Team B: " + str(ScoreManager.scores["B"])
