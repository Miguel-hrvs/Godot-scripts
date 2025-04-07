# 4-way no diagonal player moving script by: Miguel_hrvs, license: CC0
extends CharacterBody2D

const SPEED: int = 185; # Movement variable
@onready var animated_sprite = $AnimatedSprite2D;  # Get player animations
var last_direction : Vector2i = Vector2i.DOWN;  # Default facing down
var last_pressed_action : String = ""; # Default no key pressed
			
# Handle input and movement
func _physics_process(_delta: float) -> void: # Not using delta, so _
	var input_vector : Vector2i = Vector2i.ZERO; # Start with no default input
	
	# Handle input 
	for action in ["right", "left", "up", "down"]:
		if Input.is_action_just_pressed(action):
			last_pressed_action = action;
		elif Input.is_action_just_released(action) and !Input.is_action_pressed("right") and !Input.is_action_pressed("left") and !Input.is_action_pressed("up") and !Input.is_action_pressed("down"):
			last_pressed_action = "";
		# If we leave pressed a key, then we press another, release it and left pressed that other key and want it to work
		elif Input.is_action_pressed("right") and !Input.is_action_pressed("left") and !Input.is_action_pressed("up") and !Input.is_action_pressed("down"):
			last_pressed_action = "right";
		elif Input.is_action_pressed("left") and !Input.is_action_pressed("right") and !Input.is_action_pressed("up") and !Input.is_action_pressed("down"):
			last_pressed_action = "left";
		elif Input.is_action_pressed("up") and !Input.is_action_pressed("left") and !Input.is_action_pressed("right") and !Input.is_action_pressed("down"):
			last_pressed_action = "up";
		elif Input.is_action_pressed("down") and !Input.is_action_pressed("left") and !Input.is_action_pressed("right") and !Input.is_action_pressed("up"):
			last_pressed_action = "down";
	
	# Get the desired input direction
	if last_pressed_action == "right":
		input_vector.x = 1;
	elif last_pressed_action == "left":
		input_vector.x = -1;
	elif last_pressed_action == "down":
		input_vector.y = 1;
	elif last_pressed_action == "up":
		input_vector.y = -1;
	
	# Movement animations
	if input_vector != Vector2i.ZERO: # Player is moving, heading towards the correct direction
		if input_vector.x > 0:
			animated_sprite.play("move-right");
			last_direction = Vector2i.RIGHT; # Save right as last direction
		elif input_vector.x < 0:
			animated_sprite.play("move-left");
			last_direction = Vector2i.LEFT; # Save left as last direction
		elif input_vector.y < 0:
			animated_sprite.play("move-up");
			last_direction = Vector2i.UP; # Save up as last direction
		elif input_vector.y > 0:
			animated_sprite.play("move-down");
			last_direction = Vector2i.DOWN; # Save down as last direction
	else: # Player is not moving, idle animation acording to the last direction
		if last_direction == Vector2i.RIGHT:
			animated_sprite.play("idle-right");
		elif last_direction == Vector2i.LEFT:
			animated_sprite.play("idle-left");
		elif last_direction == Vector2i.UP:
			animated_sprite.play("idle-up");
		elif last_direction == Vector2i.DOWN:
			animated_sprite.play("idle-down");
		
	velocity = input_vector * SPEED; 	# Handle speed and direction
	move_and_slide() # Apply movement
