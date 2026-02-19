#class mewarisi Node (ini autoload)
#autoload itu singleton beda dengan tree dia bisa masuk tree manapun
#dan tidak akan dihapus jika tree dihapus, seperti tree itu minjam item autoload
extends Node
#referensi player dari treenya
const PLAYER = preload("uid://bf4esf57fcnh8")
const INVENTORY_DATA : InventoryData = preload("uid://b178vcvcbous1")
#membuat PLAYER menjadi instance global dengan menjadi player
var player : Player
#membuat supaya spawn hanya sekali
var player_spawned : bool = false

#function yang aktif saat masuk ke node pertama kali
func _ready() -> void:
	#alurnya player dibuat, delay 0.2 detik, player spawned
	#function add_player_instance()
	add_player_instance()
	#menunggu delay 0.2 detik
	await get_tree().create_timer( 0.2 ).timeout
	#plsyer dianggap spawned
	player_spawned = true

#function untuk meload player
func add_player_instance() -> void:
	#membuat scene tree PLAYER dan mengubahnya menjadi player
	player = PLAYER.instantiate()
	#memasukan player sebagai anak
	add_child( player )
	pass


func set_health( hp : int, max_hp : int ) -> void:
	player.max_hp = max_hp
	player.hp = hp
	player.update_hp( 0 )


#function yang aktif untuk mengatur posisi player
func set_player_position( _new_pos : Vector2 ) -> void:
	#membuat posisi player untuk player spawn
	player.global_position = _new_pos
	pass

#function yang membuat player spawn di map 
func set_as_parent( _p : Node2D ) -> void:
	#jika player mempunyai orang tua
	#player akan diputuskan dari orang tua itu
	#_p akan menjadi orang tua baru
	if player.get_parent():
		player.get_parent().remove_child( player )
	_p.add_child( player )

#function untuk memastikan player yatim piatu
func unparent_player( _p : Node2D ) -> void:
	#_p akan memutuskan hubungan anak dengan player 
	_p.remove_child( player )
