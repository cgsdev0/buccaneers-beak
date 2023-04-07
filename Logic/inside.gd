extends Area3D

func _on_body_entered(body):
	get_tree().get_first_node_in_group("player").inside = true
	get_tree().get_first_node_in_group("water").hide()

func _on_body_exited(body):
	get_tree().get_first_node_in_group("player").inside = false
	get_tree().get_first_node_in_group("water").show()
