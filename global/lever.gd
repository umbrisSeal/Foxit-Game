extends Node2D

var playerIsOnRange = false


func _ready():
	if Game.powerSwitch:
		# Power is ON
		$Sprite2D.set_texture(load("res://Sunny-land-files/Graphical Assets/environment/Props/crank-down.png"))
	else:
		# Power is OFF
		$Sprite2D.set_texture(load("res://Sunny-land-files/Graphical Assets/environment/Props/crank-up.png"))






func _process(_delta):
	if Input.is_action_just_pressed("ui_up") and Game.state == 'alive' and playerIsOnRange:
		$soundEffect.play()
		switchLever()


func switchLever() -> void:
	if Game.powerSwitch:
		# Turn OFF power.
		$Sprite2D.set_texture(load("res://Sunny-land-files/Graphical Assets/environment/Props/crank-up.png"))
		Game.powerSwitch = false
	else:
		# Turn ON power.
		$Sprite2D.set_texture(load("res://Sunny-land-files/Graphical Assets/environment/Props/crank-down.png"))
		Game.powerSwitch = true



func _on_interaction_range_body_entered(body):
	if body.name == "Player":
		playerIsOnRange = true


func _on_interaction_range_body_exited(body):
	if body.name == "Player":
		playerIsOnRange = false




