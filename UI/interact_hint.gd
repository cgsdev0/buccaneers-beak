extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	
	Story.enable_interaction.connect(self.on_show)
	Story.disable_interaction.connect(self.on_hide)
	visible = false


func on_show(char: Story.Character):
	$AnimationPlayer.play("button_down")
	self.visible = true

func on_hide():
	self.visible = false
	$AnimationPlayer.play("RESET")
