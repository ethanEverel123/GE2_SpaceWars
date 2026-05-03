# scoreboard.gd
extends Control

# scoreboard.gd
func _ready():
	add_to_group("scoreboard")
	# Red team 
	$RedTeamLabel.anchor_left = 0.0
	$RedTeamLabel.anchor_right = 0.0
	$RedTeamLabel.position = Vector2(20, 20)

	# Blue team 
	$BlueTeamLabel.anchor_left = 1.0
	$BlueTeamLabel.anchor_right = 1.0
	$BlueTeamLabel.position = Vector2(-150, 20)  # offset left by label width
	
	# Player — top right below blue
	$PlayerLabel.anchor_left = 1.0
	$PlayerLabel.anchor_right = 1.0
	$PlayerLabel.position = Vector2(-150, 50)  # move down by 30
	
	ScoreManager.score_updated.connect(update_display)
	update_display()

func update_display():
	$RedTeamLabel.text = "Red Team: " + str(ScoreManager.scores["A"])
	$BlueTeamLabel.text = "Blue Team: " + str(ScoreManager.scores["B"])
	$PlayerLabel.text = "Player: " + str(ScoreManager.scores["turret"])
