extends Node2D

func displayDiamonds():
	# Check diamonds in Game.diamonds from 1 to 5.
	if Game.diamonds[1]: get_node("Diamonds/Gem-1").modulate = Color(1, 1, 1, 1)
	if Game.diamonds[2]: get_node("Diamonds/Gem-2").modulate = Color(1, 1, 1, 1)
	if Game.diamonds[3]: get_node("Diamonds/Gem-3").modulate = Color(1, 1, 1, 1)
	if Game.diamonds[4]: get_node("Diamonds/Gem-4").modulate = Color(1, 1, 1, 1)

func _ready():
	# Read lives and display new level, if player has lives.
	if Game.lives > 0:
		# Next level
		$livesIndicator.text = "x    " + str(Game.lives)
		$levelIndicator.text = "Nivel   -   " + str(Game.level)
		displayDiamonds()
		$soundtrack.play()
	else:
		# Game Over
		Game.lives = 5
		Game.level = 0
		$gameoverSound.play()
		$livesIndicator.visible = false
		$levelIndicator.visible = false
		$PlayerIndicator.visible = false
		$Diamonds.visible = false
		$gameOverIndicator.visible = true
		pass
	pass


func _on_timer_timeout():
	#$livesIndicator.visible = false
	# Change level.
	Game.state = 'alive'
	match Game.level:
		1:
			Game.cameraLimit.x = 6720
			Game.cameraLimit.y = 0
			get_tree().change_scene_to_file("res://world_scene.tscn")
		2:
			Game.cameraLimit.x = 8640
			Game.cameraLimit.y = 0
			get_tree().change_scene_to_file("res://Levels/level2.tscn")
		3:
			Game.cameraLimit.x = 10880
			Game.cameraLimit.y = -200		# Limit for Top camera.
			Game.powerSwitch = false
			get_tree().change_scene_to_file("res://Levels/nivel3.tscn")
		4:
			# Change back to 4, only to not allow users to play this level yet.
			Game.powerSwitch = true
			Game.cameraLimit.x = 9024
			Game.cameraLimit.y = -800
			get_tree().change_scene_to_file("res://Levels/level4.tscn")
		_:
			# In case no level is found.
			print("WARNING: Level not found.")
			print("Level count reset.")
			Game.level = 1
			get_tree().change_scene_to_file("res://main_scene.tscn")

# For game finished sequence use the "Final House Goal" Object.
# Do all the required programming for showing the different endings there.
