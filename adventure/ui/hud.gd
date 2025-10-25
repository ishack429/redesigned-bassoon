extends CanvasLayer

onready var health_label := $VBoxContainer/HealthLabel
onready var score_label := $VBoxContainer/ScoreLabel

func update_health(h: int):
    health_label.text = "Health: %d" % h

func update_score(s: int):
    score_label.text = "Score: %d" % s

func _ready():
    update_score(0)