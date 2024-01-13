extends Node2D

var diamonds = 0	# Number of diamonds the player got.
var kills = 0		# Number of kills the player got.
var ending = 1		# Ending caused.
var runningEnding = false
var messages = [""]

func _ready():
	# There is no .reduce() in Godot, have to iterate along the array.
	$Darkener.visible = true
	$BackgroundNight.visible = false
	for diamond in Game.diamonds:
		if diamond: diamonds += 1
	kills = Game.money
	endingCheck()

# TRUE_VALUE if CONDITION else FALSE_VALUE
func _process(_delta):
	if not runningEnding:
		runningEnding = true
		triggerEnding(ending)


func setMessages(messageSetId):
	match(messageSetId):
		1:
			messages = [
				"Y así, el zorro pudo regresar sano y salvo a casa.",
				"Pero lamentablemente su paz no duraria para siempre",
				"ya que tendrá que realizar su viaje una vez más",
				"para buscar comida en el próximo invierno."
			]
		2:
			messages = [
				"Y así, el zorro pudo regresar sano y salvo a casa.",
				"Y con las riquezas que obtuvo en su aventura",
				"pudo costearse arbustos de bayas para comer.",
				"Ahora, sus próximos inviernos no serán tan duros",
				"pero sus viajes aún serán peligrosos."
			]
		3:
			messages = [
				"Y así, el zorro pudo regresar sano y salvo a casa.",
				"Sin embargo, al probar tanta sangre de sus víctimas",
				"el zorro se volvió enteramente carnívoro.",
				"Sus depredadores ahora huían de él",
				"y su peor temor ahora era encontrarse con el escalofriante",
				"Zorro Carnívoro de las Montañas.",
				"La vida en la montaña nunca volvió a ser la misma."
			]
		4:
			messages = [
				"Y así, el zorro pudo regresar sano y salvo a casa.",
				"Y con las riquezas que obtuvo en su aventura",
				"pudo mudarse a la mejor zona de las montañas",
				"con tantos arbustos de bayas cerca de casa",
				"que nunca más pasaría hambre en el invierno",
				"ni temería por sus depredadores."
			]



func endingCheck():
	if diamonds == 4:
		# Ending 4, best ending. All diamonds collected.
		ending = 4
		setMessages(4)
	else:
		if kills >= 80:
			# Ending 3, mass murder. More than 100 kills and not all diamonds collected.
			ending = 3
			setMessages(3)
		else:
			if diamonds > 1:
				# Ending 2, average. More than 1 diamond collected and less than 100 kills.
				ending = 2
				setMessages(2)
			else:
				# Ending 1, normal. Only 1 or less diamdons collected, less than 100 kills.
				ending = 1
				setMessages(1)



# if Game.diamonds[4]: get_node("Diamonds/Gem-4").modulate = Color(1, 1, 1, 1)

func triggerEnding(endingId: int = 1):
	# Documentation about tweens:
	# https://docs.godotengine.org/en/stable/classes/class_tween.html
	$RestartControls.visible = false	# Just in case.
	$Ending2Objects.visible = false
	$Ending3Objects.visible = false
	$Ending4Objects.visible = false
	$TileMap2.visible = false
	$Darkener.visible = true
	match(endingId):
		1:
			# Normal Ending
			# STEP 1: CHANGE OBJECTS IN SCENE
			# STEP 2: PLAY MUSIC
			print("Ending 1 triggered.")
			$SunnyEndingSoundtrack.play()
		2:
			# Average Ending
			print("Ending 2 triggered.")
			$Ending2Objects.visible = true
			$SunnyEndingSoundtrack.play()
			pass
		3:
			# Mass Murder Ending
			print("Ending 3 triggered.")
			$BackgroundNight.visible = true
			$BackgroundSunny.visible = false
			$Ending3Objects.visible = true
			$MurderEndingSoundtrack.play()
			pass
		4:
			# Best Ending
			print("Ending 4 triggered.")
			$Ending2Objects.visible = true
			$Ending4Objects.visible = true
			$TileMap2.visible = true
			$RichEndingSoundtrack.play()
			pass
		_:
			print("No ending matches the parameters:")
			print("Diamonds: ", diamonds)
			print("Kills: ", kills)
			get_tree().change_scene_to_file("res://main_scene.tscn")
	
	# Outside Match, all endings follow the next process:
	
	# STEP 3: FADE AWAY DARKENER
	var tween = get_tree().create_tween()
	tween.tween_property($Darkener, "modulate", Color(1,1,1, 1), 1.5)
	tween.tween_property($Darkener, "modulate", Color(1, 1, 1, 0), 4)
	await tween.finished
	tween.stop()
	
	# STEP 4: DISPLAY MESSAGES:
	for index in range(messages.size()):
		var tweenText = get_tree().create_tween()
		var label = Label.new()
		label.text = messages[index]
		label.modulate[3] = 0
		label.set("theme_override_font_sizes/font_size", 20)
		label.horizontal_alignment = 1
		
		var labelPosition = Vector2(0, 0)
		label.set_position(Vector2(0,0))
		labelPosition.x = (1152/2) - (label.size.x * 0.62)
		labelPosition.y = 360 + (30 * (index+1))
		label.set_position(labelPosition)
		
		# REALLY WEIRD BEHAIVIOUR -> label.size.x returns 0 always until .set_position()
		# has been used.
		# My Guess why this happens:
		"""
		1. We are creating a label from code.
		2. label.size gets the size via the position of the object.
		3. Label is still in code, no position given... so, size = 0
		4. We must give label a position (even if its not the real one)
		5. Then, .size can calculate its size using the position.
		6. If no position is provided, when doing .add_child() Godot sets it to Vector2(0,0)
		7. Then also, .size can be obtained.
		8. Anytime where you try to get .size of an object that does not exist in the node
			tree, and has no position given, .size will be 0.
		"""
		
		$TextLabels.add_child(label)
		tweenText.tween_property(label, "modulate", Color(1,1,1,1), 2.5)
		tweenText.tween_property(label, "modulate", Color(1,1,1,1), 2.5) #To wait
		await tweenText.finished
	
	# STEP 5: WAIT FOR A WHILE TO LET PLAYER READ
	var tween3 = get_tree().create_tween()
	tween3.tween_property($TextLabels, "modulate", Color(1,1,1,1), 5)
	tween3.tween_property($TextLabels, "modulate", Color(1,1,1,0), 3)
	await tween3.finished
	
	# STEP 6: PRESENT END TITLE, TRIGGER CLOCK TO PRESENT GO BACK BUTTON.
	$EndButtonTimer.start()



func _on_end_button_timer_timeout():
	$RestartControls.visible = true

func _on_go_menu_button_pressed():
	Game.lives = 5
	Game.playerHP = 3
	Game.money = 0
	Game.level = 1
	Game.diamonds = [false, false, false, false, false]
	get_tree().change_scene_to_file("res://main_scene.tscn")









