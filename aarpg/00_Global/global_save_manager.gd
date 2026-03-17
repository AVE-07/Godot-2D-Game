#script yang digunakan untuk autoload
extends Node

#mendeklarasikan save_path untuk membuat  jalan ke directory user
const SAVE_PATH = "user://"

#signa yang digunakan saat save berhasil, atau memakai save dan load game
signal game_loaded
signal game_saved

#mendeklarasikan current_save dengan menjadikannya dictionary
#dictionary ada kumpulan seluruh data penting dalam progress player
var current_save : Dictionary = {
	#scene_path yang aktif saat save
	scene_path = "",
	player = {
		hp = 1,
		max_hp = 1,
		pos_x = 0,
		pos_y = 0
	},
	#inventory player
	items = [],
	#data objek yang  sudah dibuka seperti chest dll
	persistence = [],
	#data progress quest yang sudah dikerjakan player
	quest = []
}

#function yang aktif saat save game
func save_game() -> void:
	#memanggil function untuk mengupdate data player terbaru
	update_player_data()
	#memanggil function untuk mengupdate data scene terbaru
	update_scene_path()
	update_item_data()
	#membuat variabel file yang dapat mengakses file, dengan tujuan save_path, nama file beserta kestensinya
	#lalu diberikan akses untuk menulis ulang file
	var file := FileAccess.open( SAVE_PATH + "save.json", FileAccess.WRITE )
	#membuat var save_json yang berfungsi untuk mengubah file json menjadi teks yang sangat panjang dengan
	#parameter current_save
	var save_json = JSON.stringify( current_save )
	#memasukan data save_json ke dalam file dan memberikan enter dibagian akhir data
	file.store_line( save_json )
	#mengeluarkan signal game_saved
	game_saved.emit()
	pass

#function yang aktif saat load game
func load_game() -> void:
	#membuat variabel file yang dapat mengakses file, dengan tujuan save_path, nama file beserta kestensinya
	#lalu diberikan akses untuk membaca file
	var file := FileAccess.open( SAVE_PATH + "save.json", FileAccess.READ )
	#membuat variabel json yang dapat membaca teks panjang stringify
	var json := JSON.new()
	#json membaca file yang disimpan di function save_game dan mengambil data tersebut sampai menemukan
	#enter lalu mengubah data tersebut ke dalam bentuk json
	json.parse( file.get_line() )
	#membuat variabel save_dict sebagai dictionary
	#dengan mengambil data json diubah sebagai dictionary yang dibuat di awal
	var save_dict : Dictionary = json.get_data() as Dictionary
	#membuat save_dict menjadi current_save
	current_save = save_dict
	#menjalankan function load_new_level di LevelManager dengan parameter
	#scene_path yang ada di current_save, target transition yang null, dan posisi vector2.zero
	LevelManager.load_new_level( current_save.scene_path, "", Vector2.ZERO )
	#menunggu signal level_load_started di LevelManager
	await LevelManager.level_load_started
	#menjalankan function set_player_position di PlayerManager dengan parameter
	#pos x dan y player sesuai current_save
	PlayerManager.set_player_position( Vector2(current_save.player.pos_x, current_save.player.pos_y ) )
	#menjalankan function set_health di PlayerManager dengan parameter
	#hp dan max_hp player sesuai dengan current_save
	PlayerManager.set_health( current_save.player.hp, current_save.player.max_hp )
	PlayerManager.INVENTORY_DATA.parse_save_data( current_save.items )
	#menunggu signal level_loaded di LevelManager
	await LevelManager.level_loaded
	#mengeluarkan signal game_loaded
	game_loaded.emit()
	pass

#function yang aktif untuk mengupdate data player
func update_player_data() -> void:
	#membuat variabel p menjadi Player dimana valuenya dari player yang ada di PlayerManager
	var p : Player = PlayerManager.player
	#membuat hp di p menjadi player hp di current_save
	current_save.player.hp = p.hp
	#membuat max_hp di p menjadi player max_hp di current_save
	current_save.player.max_hp = p.max_hp
	#membuat global_position dari x di p menjadi player pos_x di current_save
	current_save.player.pos_x = p.global_position.x
	#membuat global_position dari y di p menjadi player pos_y di current_save
	current_save.player.pos_y = p.global_position.y

#function yang aktif untuk mengupdate scene
func update_scene_path() -> void:
	#mendeklarasikan p sebagai string dengan value kosong (null)
	var p : String = ""
	#untuk c mengambil children yang ada di root tree
	for c in get_tree().root.get_children():
		#jika c adalah level
		if c is Level:
			#membuat c dari scene_file_path menjadi p
			p = c.scene_file_path
	#membuat p menjadi scene_path di current_save
	current_save.scene_path = p


func update_item_data() -> void:
	current_save.items = PlayerManager.INVENTORY_DATA.get_save_data()
