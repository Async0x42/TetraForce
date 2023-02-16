extends StaticBody2D

@onready var bombed = false : set = set_bombed
@onready var animation = preload("res://effects/bombable_rock_explosion2.tscn").instantiate()

@export var direction: String = "up"

signal update_persistent_state

func _ready():
	add_to_group("bombable")
	spritedir()

func bombed(show_animation=true):
	$CollisionShape2D.queue_free()
	bombed = true
	hide()
	if show_animation:
		get_parent().add_child(animation)
		animation.position = position
	emit_signal("update_persistent_state")

func set_bombed(b):
	if b:
		bombed(false)

func spritedir():
	if direction == "up":
		self.rotation_degrees = 0
		animation.rotation_degrees = 0
	elif direction == "right":
		self.rotation_degrees = 90
		animation.rotation_degrees = 90
	elif direction == "down":
		self.rotation_degrees = 180
		animation.rotation_degrees = 180
	elif direction == "left":
		self.rotation_degrees = 270
		animation.rotation_degrees = 270
