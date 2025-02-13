extends Node

@export var require_map_host: bool = true
@export var persistent: bool = false
@export var sync_creation: bool = false
@export var update_properties: Dictionary = {}
@export var enter_properties: Dictionary = {}

@onready var game = get_parent()

func _ready():
	if game.has_method("get_game"):
		game = game.get_game(self)
	elif not game.has_method("is_game"):
		game = game.get_parent()

	game.connect("player_entered",Callable(self,"player_entered"))
	network.tick.connect("timeout",Callable(self,"_tick"))
	if persistent:
		get_parent().connect("update_persistent_state",Callable(self,"update_persistent_state"))
		network.request_persistent_state(get_parent())

func _tick():
	if require_map_host && !network.is_map_host():
		return
	if is_multiplayer_authority():
		update_sync()

func player_entered(id):

	if require_map_host && !network.is_map_host():
		return
	if id == network.pid:
		return
	if persistent:
		# Enter properties are fully managed by
		# update_persistent_state() if 
		# persistent == true
		return
	if sync_creation:
		network.peer_create_id(id, get_parent().filename, get_parent().name, get_parent().get_parent())
		return
	update_enter_properties(id)

func update_enter_properties(id):
	for key in enter_properties.keys():
		enter_properties[key] = get_parent().get(str(key))
	network.peer_call_id(id, self, "receive_update", [enter_properties])

func update_sync():
	for key in update_properties.keys():
		update_properties[key] = get_parent().get(str(key))
	network.peer_call_unreliable(self, "receive_update", [update_properties])

func update_persistent_state():
	if !network.is_map_host():
		return
	for key in enter_properties.keys():
		enter_properties[key] = get_parent().get(str(key))
	network.persistent_set_state(str(get_parent().get_path()), enter_properties)

func receive_update(properties = {}):
	for key in properties.keys():
		get_parent().set(key, properties[key])
