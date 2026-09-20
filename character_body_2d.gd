extends CharacterBody2D


const SPEED = 250.0
const JUMP_VELOCITY = -430.0

var boosted := false
var boostTimer = 0.0
var cooldownTimer = 10.0

@onready var boost = $"../p1boost"
@onready var boost_label = $"../p1TimerLabel"
var boost_enabled = preload("res://p1boost-1.png-4x.png")
var boost_disabled = preload("res://p1boost-disabled-1.png-4x.png")

func _physics_process(delta: float) -> void:
	if not get_parent().play:
		velocity = Vector2.ZERO
		return
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump1") and is_on_floor():
		if boosted:
			velocity.y = JUMP_VELOCITY * 1.5
		else:
			velocity.y = JUMP_VELOCITY
			
	if Input.is_action_just_pressed("boost1") and cooldownTimer <= 0.0:
		boosted = true
		boostTimer = 0.0
	
	if boosted:
		boostTimer += delta
		cooldownTimer = 10.0
		boost.texture =  boost_disabled
		if boostTimer >= 3.0:
			boosted = false
			boostTimer = 0.0
	if not boosted and cooldownTimer > 0.0:
		cooldownTimer -= delta
	
	if cooldownTimer <= 0.0:
		boost.texture = boost_enabled
	
	if boosted:
		boost_label.text = str(ceil(3.0 - boostTimer))
	elif cooldownTimer > 0:
		boost_label.text = str(ceil(cooldownTimer))
	else:
		boost_label.text = "READY"
		
		

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("left1", "right1")
	if direction:
		if boosted:
			velocity.x = direction * SPEED * 2
		else:
			velocity.x = direction * SPEED
		if direction < 0:
			$Sprite2D.flip_h = true   # Moving left -> Flip the sprite
		elif direction > 0:
			$Sprite2D.flip_h = false  # Moving right -> Reset to normal
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
