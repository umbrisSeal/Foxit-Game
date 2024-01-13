extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

const attack = 2
const speed = 200
const money = 3		# 5 times more if kill on fly.

var state = 'Idle'
var speedVector = Vector2(0, 0)
var player	# Player node reference, will not exist if player is not found.


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _physics_process(delta):
	if state == 'Idle':
		velocity.y += delta * gravity
	move_and_slide()

func getTarget():
	var playerPosition = get_node(Game.playerNodeCurrentPath).position
	var attackAngle = self.position.angle_to_point(playerPosition)
	speedVector = Vector2.from_angle(attackAngle)
	pass

func getSpeed():
	velocity.x = speedVector.x * speed
	velocity.y = speedVector.y * speed
	pass

func kill():
	# Deletes enemy from world.
	$killedEffect.play()
	state = 'Dead'
	$Animation.play("Dead")
	velocity = Vector2(0, 0)
	await $Animation.animation_finished
	queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	player = get_node(Game.playerNodeCurrentPath)
	if player:
		var direction = (player.position - self.position).normalized()
		
		if state != 'Attack' and state != 'Dead':
			if direction.x > 0:
				$Animation.flip_h = true
			else:
				$Animation.flip_h = false
		
		if state == 'Point':
			getTarget()
		
		if state == 'Attack':
			# Put here the function "getSpeed()" if want to avoid being stopped.
			pass
		
		if state == 'Dead':
			$AttackRange.monitorable = false
			$DamangeRange.monitorable = false
			pass


func _on_vision_range_body_entered(body):
	if body.name == 'Player' and state == 'Idle' and player:
		# Player on sight
		state = 'Point'
		$Animation.play("Point")
		$PointTimer.start()

func _on_point_timer_timeout():
	# Player warned, initate attack if still alive.
	if state != 'Dead':
		state = 'Attack'
		$Animation.play("Attack")
		getSpeed()
		$CollisionArea.disabled = true
		$AttackTimer.start()

func _on_attack_timer_timeout():
	# Enemy disapears after 10 seconds of attack initiated and not being killed.
	if state != 'Dead':
		queue_free()
	pass # Replace with function body.



func _on_attack_range_body_entered(body):
	if body.name == "Player" and state != 'Dead':
		# Eagle hit player.
		Game.playerHP -= attack
		kill()
		pass
	pass # Replace with function body.


func _on_damange_range_body_entered(body):
	if body.name == 'Player' and state != 'Dead':
		# Player hit enemy.
		if state == 'Attack':
			# More money if killed on fly.
			Game.money += money * 5
		else:
			Game.money += money
		kill()
		pass
	pass # Replace with function body.









