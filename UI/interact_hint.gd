extends Label


# Called when the node enters the scene tree for the first time.
func _ready():
	Story.enable_interaction.connect(self.on_show)
	visible = false


func on_show(a: bool):
	self.visible = a

