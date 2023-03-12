extends Node2D



# Connect all functions

func _ready():
	var mapi = get_tree().get_multiplayer()
	mapi.peer_connected.connect(self._player_connected)
	mapi.peer_disconnected.connect(self._player_disconnected)
	mapi.connected_to_server.connect(self._connected_ok)
	mapi.connection_failed.connect(self._connected_fail)
	mapi.server_disconnected.connect(self._server_disconnected)

# Player info, associate ID to data

var player_info = {}
# Info we send to other players
var my_info = { name = "Johnson Magenta", favorite_color = Color8(255, 0, 255) }

func _player_connected(id):
	# Called on both clients and server when a peer connects. Send my info to it.
	rpc_id(id, "register_player", my_info)
	if multiplayer.is_server():
		var character = preload("res://player.tscn").instantiate()
		# Set player id.
		character.pid = id
		# Randomize character position.
		var pos := Vector2.from_angle(randf() * 2 * PI)
		character.position = Vector2(80, 80)
		character.name = str(id)
		$Players.add_child(character, true)

func _player_disconnected(id):
	player_info.erase(id) # Erase player from info.

func _connected_ok():
	pass # Only called on clients, not server. Will go unused; not useful here.

func _server_disconnected():
	pass # Server kicked us; show error and abort.

func _connected_fail():
	pass # Could not even connect to server; abort.

@rpc
func register_player(info):
	# Get the id of the RPC sender.
	var id = get_tree().get_multiplayer().get_remote_sender_id()
	# Store the info
	player_info[id] = info

	# Call function to update lobby UI here

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_left"):
		var peer = WebSocketMultiplayerPeer.new()
		peer.create_server(4000)
		get_tree().get_multiplayer().multiplayer_peer = peer
	if Input.is_action_just_pressed("ui_right"):
		var peer = WebSocketMultiplayerPeer.new()
		peer.create_client("ws://127.0.0.1:4000")
		get_tree().get_multiplayer().multiplayer_peer = peer
	pass
