extends CharacterBody2D

const SPEED : int = 70;
const JUMP_VELOCITY : int = -300;

@onready var animated_sprite = $AnimatedSprite2D;  # Get player animations
var last_direction : Vector2i = Vector2i.RIGHT;  # Default facing right
var last_pressed_action : String = ""; # Default no key pressed

func _physics_process(delta : float) -> void:
	var input_vector : Vector2i = Vector2i.ZERO; # Start with no default input
	
	# Add the gravity.
	if not is_on_floor() : velocity += get_gravity() * delta;

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor() : velocity.y = JUMP_VELOCITY;
	
	# Handle horizontal input
	for action in ["right", "left", "up", "jump"]:
		if Input.is_action_just_pressed(action): last_pressed_action = action;
		elif Input.is_action_just_released(action) and !Input.is_action_pressed("right") and !Input.is_action_pressed("left") and !Input.is_action_pressed("up") and !Input.is_action_pressed("jump"):
			last_pressed_action = "";
		# If we leave pressed a key, then we press another, release it and left pressed that other key and want it to work
		elif Input.is_action_pressed("right") and !Input.is_action_pressed("left") and !Input.is_action_pressed("up") and !Input.is_action_pressed("jump"):
			last_pressed_action = "right";
		elif Input.is_action_pressed("left") and !Input.is_action_pressed("right") and !Input.is_action_pressed("up") and !Input.is_action_pressed("jump"):
			last_pressed_action = "left";
		elif Input.is_action_pressed("right") and !Input.is_action_pressed("left") and Input.is_action_pressed("up") and !Input.is_action_pressed("jump"):
			last_pressed_action = "right-up";
		elif Input.is_action_just_pressed("right") and Input.is_action_pressed("left") and Input.is_action_pressed("up") and !Input.is_action_pressed("jump"):
			last_pressed_action = "right-up";
		elif Input.is_action_just_pressed("left") and Input.is_action_pressed("left") and Input.is_action_pressed("up") and !Input.is_action_pressed("jump"):
			last_pressed_action = "left-up";
		elif Input.is_action_pressed("left") and !Input.is_action_pressed("right") and Input.is_action_pressed("up") and !Input.is_action_pressed("jump"):
			last_pressed_action = "left-up";
		elif Input.is_action_pressed("up") and !Input.is_action_pressed("left") and !Input.is_action_pressed("right") and !Input.is_action_pressed("jump"):
			last_pressed_action = "up";
		elif Input.is_action_pressed("jump") and !Input.is_action_pressed("left") and Input.is_action_pressed("right") and !Input.is_action_pressed("up"):
			last_pressed_action = "right-jump";
		elif Input.is_action_pressed("jump") and Input.is_action_pressed("left") and !Input.is_action_pressed("right") and !Input.is_action_pressed("up"):
			last_pressed_action = "left-jump";
		elif Input.is_action_pressed("jump") and !Input.is_action_pressed("left") and Input.is_action_pressed("right") and Input.is_action_pressed("up"):
			last_pressed_action = "right-up-jump";
		elif Input.is_action_pressed("jump") and Input.is_action_pressed("left") and !Input.is_action_pressed("right") and Input.is_action_pressed("up"):
			last_pressed_action = "left-up-jump";
	
	# Get the desired input direction
	match last_pressed_action:
		"right", "right-up", "right-jump", "right-up-jump": input_vector.x = 1; animated_sprite.flip_h = false;
		"left", "left-up", "left-jump", "left-up-jump": input_vector.x = -1; animated_sprite.flip_h = true;
		"up" : input_vector.x = 0;
	
	# Handle animations
	if input_vector != Vector2i.ZERO: # Player is moving
		match last_pressed_action: 
			"right", "left": animated_sprite.play("walking");
			"right-up", "left-up": animated_sprite.play("walking_looking_up");
			"up", "jump", "right-jump", "left-jump": animated_sprite.play("looking_up");
	else: # Player isn't moving
		match last_pressed_action:
			"up", "jump": animated_sprite.play("looking_up");
			"" : animated_sprite.play("idle");
		
	velocity.x = input_vector.x * SPEED; # Handle speed and direction
	move_and_slide();