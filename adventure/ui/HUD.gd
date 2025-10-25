# HUD controller (CanvasLayer)
extends CanvasLayer

@onready var health_label := $VBoxContainer/HBoxContainer/HealthLabel
@onready var score_label := $VBoxContainer/ScoreLabel
@onready var level_label := $VBoxContainer/LevelLabel

var health := 5 setget set_health
var score := 0 setget set_score
var level_name := "Level 1" setget set_level_name

func _ready():
	_update_ui()

func set_health(value):
	health = max(value, 0)
	_update_ui()

func set_score(value):
	score = value
	_update_ui()

func set_level_name(value):
	level_name = value
	_update_ui()

func _update_ui():
	if health_label:
		health_label.text = "Health: %d" % health
	if score_label:
		score_label.text = "Score: %d" % score
	if level_label:
		level_label.text = "%s" % level_name

func on_pause_button_pressed():
	get_tree().paused = not get_tree().paused