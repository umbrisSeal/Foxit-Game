extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready():
	if Game.diamonds[Game.level]:
		queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass




func _on_body_entered(body):
	if body.name == "Player":
		$ItemPicked.play()
		self.visible = false
		Game.diamonds[Game.level] = true
		await $ItemPicked.finished
		queue_free()
	pass # Replace with function body.
