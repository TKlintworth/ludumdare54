class_name DamageNumber2D
extends Node2D

@onready var label:Label = %Label
@onready var label_container:Node2D = %LabelContainer
@onready var ap:AnimationPlayer = %AnimationPlayer

func _ready():
	pass
	
func set_values_and_animate(value:String, start_pos:Vector2, height:float, spread:float) -> void:
	print("set values and animate")
	label.text = value
	ap.play("new_animation")
	
	var tween = get_tree().create_tween()
	var end_pos = Vector2(randf_range(-spread, spread), -height) + start_pos
	var tween_length = ap.get_animation("new_animation").length
	
	tween.tween_property(label_container, "position", end_pos, tween_length).from(start_pos)

func remove():
	ap.stop()
	if is_inside_tree():
		get_parent().remove_child(self)
