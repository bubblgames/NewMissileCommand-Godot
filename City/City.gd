extends Area2D

signal city_hit

func _on_City_area_entered(area):
	if area.name != "Ground":
		emit_signal("city_hit")
		queue_free()
