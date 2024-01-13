extends Node2D


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		Game.state = 'win'
		var levelSoundtrack = get_parent().get_node("soundtrack")
		if levelSoundtrack:
			levelSoundtrack.stop()
		$LevelCompleteEffect.play()
		await $LevelCompleteEffect.finished
		Game.level += 1
		Game.playerHP = 3
		get_tree().change_scene_to_file("res://escenas/ready.tscn")
