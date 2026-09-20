extends CharacterBody2D


const SPEED = 250.0
const JUMP_VELOCITY = -430.0


func _physics_process(delta: float) -> void:
	if not get_parent().play:
		velocity = Vector2.ZERO
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump2") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left2", "right2")
	if direction:
		velocity.x = direction * SPEED
		if direction < 0:
			$Sprite2D.flip_h = true   # Moving left -> Flip the sprite
		elif direction > 0:
			$Sprite2D.flip_h = false  # Moving right -> Reset to normal
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
