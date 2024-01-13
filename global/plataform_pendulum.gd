extends StaticBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	#self.rotation = deg_to_rad(34)
	pass # Replace with function body.


const stickyPlayer = true	# Enalbe or disables sticky effect. (not working)
const maxAcceleration = deg_to_rad(0.05)

var acceleration = 0
var currentSpeed = 0


# One major problem if we do our own physics is that our speeds would be unit/frame.
# Instead of unit/second, so it mith move too fast or too slow, dependding on game.
# We will use a timer to verify to change our values every second.




# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Game.powerSwitch:
		movePlataform()




func limitRotation(newRotation):
	newRotation = snapped(newRotation, 0.1)
	if newRotation > deg_to_rad(90):
		return deg_to_rad(90)
	else:
		if newRotation < deg_to_rad(-90):
			return deg_to_rad(-90)
	return newRotation


func movePlataform() -> void :
	# Detect where to move
	# Positive is left, right is negative, max inclination -1.57RAD = -90°
	# Our acceleration force must act in an opositie way so:
	""""
	print("Current Rotation: ", rotation)
	if rotation > 0:
		print("Gravity towards right side, Negative Rotation required")
		direction = false
	else:
		direction = true
		print("Gravity towards left side, Positive Rotation required")
		pass
	"""
	
	# Now we must get the intensity of our gravity.
	# Using SIN we must move from -1 to 1 using inputs of 90 -90° (1.5 RAD)
	acceleration = snapped(-sin(rotation) * maxAcceleration, 0.0001)
	
	# Now we must set this to set the change of angle as speed.
	currentSpeed += acceleration
	
	# Now we move the specified RAD/seconds given.
	rotation = rotation + currentSpeed



# Code to stick and leave player, second try to avoid asyncronus effects.

func attachPlayer(attach: bool) -> void:
	# This function detects if want to attach or detach player.
	# What I try to do is that this can never ocurr twice at the same time... i expect.
	if attach and stickyPlayer:
		#if get_node("../../Player"):
		#	get_node("../../Player").reparent(self)
		if get_node("../../Player/Player"):
			get_node("../../Player/Player").reparent(self)
			$Player.rotation = 0	# No rotation, with respect to the plataform. (once attached).
	else:
		if $Player:
			#print(get_node("../../Player"))
			#$Player.rotation = 0
			#$Player.rotation = 0
			#$Player/Player.rotation = 0		# Jump corrected, but Sprite is rotated.
			#$Player.rotation = 0
			#$Player.position = Vector2(0, 0)
			#print($Player.position)
			#$Player.rotation = 0
			$Player.reparent(get_node("../../Player"))
			# Re-rotate body, AFTER is detached from plataform
			if get_node("../../Player/Player"):
				get_node("../../Player/Player").rotation = 0

# NOTA: Si la rotacion se pone a 0, toma como referencia el nodo padre... en este caso siempre estaba intentando resetear MIENTRAS estaba aun en la plataforma y por eso lo tomaba como rotacion 0, lo correcto es que la rotacion se resetee DESPUES de cambiar el nodo padre al nodo "Player".




# Code to stick and leave player.

func _on_sticky_area_body_entered(body):
	if body.name == "Player" and !Input.is_action_just_pressed("ui_accept"):
		# IMPORTANT NOTE, I had problems with this. It seems that when using signals and we are referencing a node, we must add an IF to make sure the node still exists. Because is a asyncronus function, when this signal is working, the node might be moved and then attempted to enter right after which causes a "null node reference" error.
		"""
		if get_node("../../Player"):
			get_node("../../Player").reparent(self)
		"""
		# Stick player to the plataform.
		#if get_node("../../Player"):
		#	$"../../Player".reparent(self)
		$StickyArea.monitoring = false
		attachPlayer(true)
		$DestickyArea.monitoring = true



func _on_desticky_area_body_exited(body):
	if body.name == "Player":
		$DestickyArea.monitoring = false
		attachPlayer(false)
		$StickyArea.monitoring = true
