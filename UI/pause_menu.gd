extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

var prev_mouse_mode = Input.MOUSE_MODE_CAPTURED
func _input(event):
	if event.is_action_pressed("pause"):
		self.visible = !self.visible
		get_tree().paused = !get_tree().paused
		if visible:
			prev_mouse_mode = Input.mouse_mode
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			Input.mouse_mode = prev_mouse_mode
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
