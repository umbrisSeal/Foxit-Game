extends Label

func _process(delta):
	# Function called every frame.
	var display = "HP: %d" % Game.playerHP
	text = display
