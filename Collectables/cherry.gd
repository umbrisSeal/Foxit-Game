extends Area2D


func _on_body_entered(body):
	if body.name == "Player":
		$ItemPickedEffect.play()
		Utilities.heal(1)
		var tween = get_tree().create_tween()
		var tween2 = get_tree().create_tween()
		tween.tween_property(self, "position", position - Vector2(0, 25), 0.3)
		tween2.tween_property(self, "modulate:a", 0, 0.2)
		tween.tween_callback(queue_free)
