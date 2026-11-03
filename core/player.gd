extends Area2D

# signals to know what the player should do when something occurs in
# the environment or anywhere outside of its scope
signal hit # when the player gets hit

# misc stuff
@export var speed = 400 # How fast the player will move (pixels/sec).
var screen_size # Size of the game window.

# playerdata
@export var max_hp = 5 # the maximum hp of the player
var hp = max_hp # the current hp of the player

# Called when the node enters the scene tree for the first time.
func _ready() -> void: screen_size = get_viewport_rect().size

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	# handle the input, which returns the velocity vector,
	# and then feed that vector into the animation handler
	# to know what animations should be used
	handle_animation(handle_input(delta))	

# helpers
func handle_input(delta: float) -> Vector2:
	# INPUT HANDLING
	var velocity = Vector2.ZERO # reset the player's velocity for snappy movement
	
	# you want to add the velocity and not set it so that pressing
	# opposite keys cancel each other out
	if Input.is_action_pressed("left"): velocity.x -= 1
	if Input.is_action_pressed("right"): velocity.x += 1
	
	
	position += velocity * delta * speed # add the velocity
	position = position.clamp(Vector2.ZERO, screen_size) # clamp to the screen
	
	return velocity
func handle_animation(velocity: Vector2) -> void:
	# check what animation to use
	if velocity.x != 0:
		$AnimatedSprite2D.animation = "walk"
		$AnimatedSprite2D.flip_h = velocity.x < 0
	else: $AnimatedSprite2D.animation = "idle"
	
	# play it
	$AnimatedSprite2D.play()

# this is for when the player gets inside an enemy
func _on_body_entered(_body):
	hp -= 1 # remove a hp
	hit.emit() # sends the hit signal
	
# this is to reset the player when the game starts
func start(pos):
	# set the current position to the start position
	position = pos
	
	# reset the animation
	$AnimatedSprite2D.animation = "idle"
	$AnimatedSprite2D.play()
