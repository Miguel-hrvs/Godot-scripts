# Fence door animated when passing it by: Miguel_hrvs, license: CC0
extends AnimatableBody2D

@onready var animated_sprite = $AnimatedSprite2D;  # Get shop-door animations

func _ready() -> void: # Initial state
	animated_sprite.play("idle");
	
func _on_area_2d_ready() -> void: # Just added to avoid a warning
	pass;
	
func _on_area_2d_body_entered(_body: Node2D) -> void: # State when something enters
	animated_sprite.play("opening");

func _on_area_2d_body_exited(_body: Node2D) -> void: # State when something left
	animated_sprite.play("closing");
