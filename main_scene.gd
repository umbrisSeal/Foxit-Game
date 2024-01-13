extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Call function to save game.
	# Godot Identifies each script as a class.
	#Utilities.saveGame()
	Utilities.testingMessage()
	Utilities.loadGame()
	Game.playerHP = 3
	Utilities.saveGame()
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_play_button_pressed():
	# This function was created atuomatically via creating a Signal "pressed" on "playButton Object".
	# To change to other scene:
	
	#get_tree().change_scene_to_file("res://world_scene.tscn")
	get_tree().change_scene_to_file("res://escenas/ready.tscn")
	
	
	pass # Replace with function body.

func _on_quit_button_pressed():
	get_tree().quit()
