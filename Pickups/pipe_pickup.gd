extends Node3D

@export var pickup_type: GameState.Pickup = GameState.Pickup.PIPE

var consumed = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimationPlayer.play("spin")

func _on_area_3d_body_entered(body):
	if consumed:
		return
	consumed = true
	GameState.pickup(pickup_type)
	self.queue_free()
