extends Label

@onready var player = get_node("../../Player/Player")


func _process(delta):
	var display = "Victims = " + str(Game.money)
	text = display
