extends Node

const SAVE_PATH = "res://savegame.bin"

func saveGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"playerHP": Game.playerHP,
		"money": Game.money,
	}
	var jsonString = JSON.stringify(data)
	file.store_line(jsonString)
	print("Game saved.")

func loadGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH) == true:
		if not file.eof_reached():
			#Start loading
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				Game.playerHP = current_line["playerHP"]
				Game.money = current_line["money"]
	# For this version of Godot (+4) you are no longer required to close the file.
	print("Game loaded.")

func heal(healHP):
	if Game.playerHP < 3:
		Game.playerHP += healHP

func testingMessage():
	print("The conection with Utilities Class work.")
