# scoreboard.gd
extends Control

# scoreboard.gd
func _ready():
	add_to_group("scoreboard")
	# Red team — top left
	$RedTeamLabel.anchor_left = 0.0
	$RedTeamLabel.anchor_right = 0.0
	$RedTeamLabel.position = Vector2(20, 20)

	# Blue team — top right
	$BlueTeamLabel.anchor_left = 1.0
	$BlueTeamLabel.anchor_right = 1.0
	$BlueTeamLabel.position = Vector2(-150, 20)  # offset left by label width
	
	ScoreManager.score_updated.connect(update_display)
	update_display()

func update_display():
	$RedTeamLabel.text = "Team A: " + str(ScoreManager.scores["A"])
	$BlueTeamLabel.text = "Team B: " + str(ScoreManager.scores["B"])
