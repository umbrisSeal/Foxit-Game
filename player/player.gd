extends CharacterBody2D


const SPEED = 300.0
#const JUMP_VELOCITY = -400.0
const JUMP_VELOCITY = -350.0
var doubleJump = true

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")


# get_node expected to run in runtime, inside a function. If not avialable, use onready.
#@onready var animation = get_node("AnimatedSprite2D")
@onready var animation = get_node("AnimationPlayer")
var direction = 1


# Our animation function
func _ready():
	animation.play("Idle")
	$Camera2D.limit_right = Game.cameraLimit.x
	$Camera2D.limit_top = Game.cameraLimit.y

func _process(_delta):
	var playerNodePath = get_path()
	Game.playerNodeCurrentPath = str(playerNodePath)



func _physics_process(delta):
	# Add the gravity. called 600-6000 times per second.
	if not is_on_floor():
		velocity.y += (gravity * delta) * 0.80

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor() and Game.state == 'alive':
		# Seems that "is action" is predifined as Space Bar.
		animation.play("Jump")
		$soundJump.play()
		velocity.y = JUMP_VELOCITY


	# My Double Jump
	#if Input.is_action_just_pressed("ui_accept") and doubleJump and not is_on_floor():
	#	velocity.y = JUMP_VELOCITY * 0.80
	#	doubleJump = false
	#if is_on_floor():
	#	doubleJump = true


	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	#var direction = Input.get_axis("ui_left", "ui_right")
	if Input.is_anything_pressed():
		if Input.is_physical_key_pressed(KEY_A) or Input.is_physical_key_pressed(KEY_LEFT):
			direction = -1
		else:
			if Input.is_physical_key_pressed(KEY_D) or Input.is_physical_key_pressed(KEY_RIGHT):
				direction = 1
	else:
		direction = 0
	# Direction static = 0, right = 1, left = -1
	if Game.state == 'alive':
		if direction:
			if direction == -1:
				get_node("AnimatedSprite2D").flip_h = true
			else:
				get_node("AnimatedSprite2D").flip_h = false
			
			velocity.x = direction * SPEED
			if velocity.y == 0:
				animation.play("Run")
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.y == 0:
				animation.play("Idle")
			if velocity.y > 0:
				animation.play("Fall")
	else:
		velocity.x = 0
		if Game.state == 'dead':
			animation.play("Death")
		else:
			animation.play("Idle")
	
	# Kill player if falls from screen.
	if position.y > 700:
		Game.playerHP = 0
	
	
	move_and_slide()
	
	# Why this is inside the pysics??
	# We should handle this differently. To call state in global function to act in world scene.
	# This code should be handeled eihter in each level scene or in a utilities function to be able
	# to be called in any scene and link it to this character.
	
	if Game.playerHP <= 0 and Game.state == 'alive':
		# If state is eliminated, game will keep entering this function (will not wait for await).
		print("Player has died")
		Game.state = 'dead'
		Game.playerHP = 0
		Game.lives -= 1
		var soundtrackNode = get_parent().get_parent().get_node("soundtrack")
		if soundtrackNode:
			# Always check that your parent node exists before using it.
			# In this case we use:
			# Player (this one) > Player (node defined in WS) > World Scene (WS) > soundtrack.
			soundtrackNode.stop()
		$PlayerDiedEffect.play()
		await $PlayerDiedEffect.finished
		queue_free()
		if Game.lives > 0:
			# Player still have lives
			Game.state = 'alive'
			Game.playerHP = 3
		else:
			# Game Over
			Game.state = 'alive'
			Game.money = 0
			Game.playerHP = 3
			Utilities.saveGame()
			
		get_tree().change_scene_to_file("res://escenas/ready.tscn")

# Player Reached goal, make him invincible, play music, then change scene.

# Function and methods to make one-way collisions in certain tiles of a tileset.


func _on_tile_detector_body_shape_entered(body_rid: RID, body: Node2D, body_shape_index: int, local_shape_index: int) -> void:
	"""
	So, this is kind of a complex signal for an Area2D, the body_shape_entered returns not only the body, but also:
		# Note, I added the data types for each value input. Also, added the void return.
		
		body_rid (RID): Body resource ID, an ID that godot creates to identify a resource.
			Having body_rid that means you refer to physics body RID.
		body: A body, that we expect as a Node2D node or child of it.
		body_shape_index: Index of collision shape, during a collition, it helps to identify a
			singular thing that caused this to trigger.
		local_shape_index: The index of the collision detector, that is, the index of our Area2D
			that have linked this detector.
	"""
	# I will do this later man, its kind of confusing.
	# I should read the documentation first.
	pass # Replace with function body.



