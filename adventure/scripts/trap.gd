extends Area2D

@export var damage := 1
@export var knockback := Vector2(0, -280)
@export var one_shot := false

signal triggered(by)

func _ready():
    connect("body_entered", Callable(self, "_on_body_entered"))

func _on_body_entered(body):
    if body.is_in_group("player"):
        if body.has_method("damage"):
            body.damage(damage, knockback)
            emit_signal("triggered", body)
            if one_shot:
                queue_free()