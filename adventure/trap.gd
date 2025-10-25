# Generic trap node. Type "saw" oscillates, type "spikes" can extend/retract.
extends Node2D

@export var trap_type: String = "saw" # "saw" or "spikes"
@export var damage: int = 1
@export var amplitude: float = 48.0 # for saw vertical oscillation
@export var speed: float = 3.0
@export var retract_time: float = 1.0

var _time := 0.0
var _base_position := Vector2.ZERO

func _ready():
	_base_position = position
	# Connect area collisions if present
	if $Area2D:
		$Area2D.connect("body_entered", Callable(self, "_on_body_entered"))

func _physics_process(delta):
	_time += delta
	match trap_type:
		"saw":
			# simple vertical oscillation
			position.y = _base_position.y + sin(_time * speed) * amplitude
			$Sprite.rotation_degrees = _time * 360.0 * 0.2
		"spikes":
			# animate spikes using a simple timer (could be animated with AnimationPlayer)
			var t = fmod(_time, retract_time * 2)
			var factor = t < retract_time ? t / retract_time : (2 - t / retract_time)
			position.y = _base_position.y + (1 - factor) * -12.0

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if body.has_method("take_damage"):
			body.take_damage(damage)