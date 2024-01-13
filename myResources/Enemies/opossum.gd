extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var direction = false	# True = right, False = Left
var state = 'Alive'

const speed = 100
const attack = 1
const money = 3


func _ready():
	pass # Replace with function body.


func _process(_delta):
	if state == 'Alive':
		velocity.x = speed if direction else -speed
		# This is how ternary works in godot:
		# Instead of: CONDITION ? TRUE_VALUE : FALSE_VALUE
		# We use:
		# TRUE_VALUE if CONDITION else FALSE_VALUE
		$Animation.flip_h = direction


func _physics_process(delta):
	if state == 'Alive':
		velocity.y += gravity * delta
	
	move_and_slide()


func kill():
	state = "Dead"
	$AttackRange.monitoring = false
	$DamangeRange.monitoring = false
	velocity = Vector2(0, 0)
	$Animation.play("Dead")
	$killedEffect.play()
	await $Animation.animation_finished
	queue_free()


func _on_right_eye_body_exited(body):
	if state != 'Dead' and is_instance_valid(TileMap):
		#print("My rigth eye saw: ", body)
		#print("I will switch direction!")
		direction = !direction

func _on_left_eye_body_exited(body):
	if state != 'Dead' and is_instance_valid(TileMap):
		#print("My left eye saw: ", body)
		#print("I will switch direction!")
		direction = !direction

func _on_attack_range_body_entered(body):
	# Enemy attacked player.
	if body.name == "Player" and state != 'Dead':
		Game.playerHP -= attack
		kill()

func _on_damange_range_body_entered(body):
	# Player killed enemy.
	if body.name == "Player" and state != 'Dead':
		Game.money += money
		kill()



