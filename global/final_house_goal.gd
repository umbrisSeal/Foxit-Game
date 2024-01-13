extends Node2D




func _on_goal_area_body_entered(body):
	if body.name == "Player":
		Game.state = 'win'
		var levelSoundtrack = get_parent().get_node("soundtrack")
		if levelSoundtrack:
			levelSoundtrack.stop()
		$GameCompleteEffect.play()
		await $GameCompleteEffect.finished
		
		# Finish the game, send the player to the ending screen.
		get_tree().change_scene_to_file("res://escenas/ending_screen.tscn")

