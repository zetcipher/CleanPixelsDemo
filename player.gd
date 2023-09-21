extends CharacterBody2D

# Basic template provided by Godot, but lightly modified.
# I'm not going to bother making some elaborate character controller for a graphics demo.
# Changes from the template:
# Animation stuff
# Coyote time
# Acceleration/deceleration
# Typed vars/constants

const SPEED := 110.0
const JUMP_VELOCITY := -300.0
const COYOTE_TIME := 5.0 / 60.0 # 5 frames 

signal moved(pos: Vector2)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity : float = ProjectSettings.get_setting("physics/2d/default_gravity")

var air_time := 0.0


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		air_time += delta
	else:
		air_time = 0.0
	
	if air_time > COYOTE_TIME:
		velocity.y += gravity * delta

	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and air_time < COYOTE_TIME:
		velocity.y = JUMP_VELOCITY
		air_time = COYOTE_TIME

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = move_toward(velocity.x, SPEED * direction, SPEED * 0.125)
		$AnimatedSprite2D.flip_h = bool(direction - 1.0) # Left = -2.0 (true)  /  Right = 0.0 (false)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED * 0.25)
	
	# Animations
	if air_time > COYOTE_TIME:
		$AnimatedSprite2D.play("air")
	elif direction:
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("default")
	
	# Redirecting the move_and_slide() call to a new function, so we can emit the "moved" signal.
	# Doing this in another function may not be necessary for a super simple character controller like this one.
	# However, with more complex character controllers, and especially ones that utilize state machines,
	# this ensures you're not duplicating code, and then potentially needing to change it in multiple places.
	move()


func move():
	move_and_slide()
	# We set the global_position of the sprite, rather than the position,
	# because position is relative to the parent node, and global_position is not.
	$AnimatedSprite2D.global_position = self.global_position.snapped(Vector2.ONE)
	# Emitting the "moved" signal, with the player's position as the provided argument.
	emit_signal("moved", position)
