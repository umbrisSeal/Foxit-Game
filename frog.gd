extends CharacterBody2D


# Called when the node enters the scene tree for the first time.
func _ready():
	frogAnimation.play("Idle")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var player
var chase = false
var speed = 50
var attack = 1
var alive = true
var jumpReady = true
var state = 'land'
@onready var frogAnimation = get_node("AnimatedSprite2D")

const jumpVelocity = -400	# Speed of jump upwards y.
const maxSpeed = 140	# Max horizontal speed allowed.
#const jumpReloadTimeSec = 2		# Not being used, set directly in time node.

func getSpeed():
	# Get speed according player's position, without exiding maxSpeed.
	var player = get_node("../../Player/Player")
	var speed = player.position.x - self.position.x
	if abs(speed) > maxSpeed:
		if speed > 0:
			return maxSpeed
		else:
			return -maxSpeed
	else:
		return speed
	


func _physics_process(delta):
	# Gravity for our frog
	if state != 'Dead':
		velocity.y += gravity * delta
	else:
		$DamangeRange.monitoring = false
		$PlayerDeath.monitoring = false
		velocity = Vector2(0, 0)
	
	if !jumpReady and $JumpReload.is_stopped():
		# Jump has been used, wait to reload jump.
		$JumpReload.start()
	
	if chase:
		# Frog is chasing player.
		# Frog watch player in the correct direction.
		var player = get_node("../../Player/Player")
		var direction = (player.position - self.position).normalized()
		
		
		if state == 'land':
			# Frog changes direction when is on land.
			if direction.x > 0:
				get_node("AnimatedSprite2D").flip_h = true
			else:
				get_node("AnimatedSprite2D").flip_h = false
			
			# Frog jumps when ready.
			if jumpReady:
				print("Jump Ready! I wanna jump!")
				jumpReady = false
				velocity.y = jumpVelocity	# Frog jumps
				state = 'jumping'
				# Frog moves towards player.
				velocity.x = getSpeed()
	else:
		# Frog is not chasing player.
		if frogAnimation.animation != "Death":
			frogAnimation.play("Idle")
		pass
	
	# Manage frog animations when jumping.
	if velocity.y < 0 and !is_on_floor() and frogAnimation.animation != "Death":
		frogAnimation.play("Jump")
	if velocity.y > 0 and !is_on_floor() and frogAnimation.animation != "Death":
		frogAnimation.play("Fall")
		state = 'landing'
	if is_on_floor() and state == 'landing' and frogAnimation.animation != "Death":
		frogAnimation.play("Idle")
		velocity = Vector2(0, 0)
		state = 'land'
	
	move_and_slide()

func _on_player_detection_area_body_entered(body):
	if body.name == "Player":
		print("I see you!")
		chase = true

func _on_player_detection_area_body_exited(body):
	if body.name == "Player" and frogAnimation.animation != "Death" :
		print("Hey, where did you go?")
		chase = false

func _on_damange_range_body_entered(body):
	# Player was attacked by enemy.
	# Enemy explotes dealing damange to the player.
	if body.name == "Player" and alive:
		state = 'Dead'
		if Game.state == 'alive':
			# Check if player is still alive to damange him.
			$enemyKilled.play()
			Game.playerHP -= attack
		$PlayerDeath.monitoring = false		# Player cannot kill enemy once it damages him
		chase = false
		velocity.x = 0
		frogAnimation.play("Death")
		await frogAnimation.animation_finished
		print("Ha! I hit you first!")
		self.queue_free()

func _on_player_death_body_entered(body):
	# Player defeated enemy.
	if body.name == "Player":
		state = 'Dead'
		$enemyKilled.play()
		if Game.state == 'alive':
			Game.money += 1
		velocity.x = 0
		chase = false
		alive = false
		frogAnimation.play("Death")
		await frogAnimation.animation_finished
		print("Aaaahh!! You defeated me!")
		self.queue_free()



func _on_jump_reload_timeout():
	# Jump has reloaded.
	jumpReady = true
	print("Frog jump ready.")











