#global node yang dijadikan autoload, bisa diakses dimanapun dengan LevelManager
extends Node
#sinyal yang dikirim saat level transition
signal level_load_started
signal level_loaded
#sinyal yang dikirim saat bounds tilemap berubah
#dengan parameter array[top_left, bottom_right]
signal TileMapBoundsChanged( bounds : Array[ Vector2 ] )

#menyimpan data target transition, dan posisi player untuk level transition
var target_transition : String
var position_offset : Vector2
#menyimpan batas tile map yang sedang aktif
var current_tilemap_bounds : Array[ Vector2 ]


func _ready() -> void:
	#memastikan satu frame dijalankan dulu sebelum emit sinyal
	await get_tree().process_frame
	#emit sinyal level_loaded
	level_loaded.emit()

#fungsi yang digunakan saat mengubah tilemap
func ChangeTileMapBounds( bounds : Array[ Vector2 ] ) -> void:
	#saat tilemap berubah dia akan memberi pemberitahuan bahwa bounds berubah
	#seluruh node yang terkoneksi dengan sinyal ini akan mengetahuinya
	current_tilemap_bounds = bounds
	TileMapBoundsChanged.emit( bounds )

#function yang aktif untuk pergantiap level
func load_new_level(
	#membuat variabel untuk data yang dibutuhkan, dari map, lokasi transition, posisi player
	level_path : String,
	_target_transition : String,
	_position_offset : Vector2
) -> void:
	#mempause scene tree
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	#menunggu animasi fade_out() selesai
	await SceneTransition.fade_out()
	#emit sinyal level_load_started
	level_load_started.emit()
	#memastikan satu frame dijalankan dulu sebelum emit sinyal
	await get_tree().process_frame
	#mengubah map satu ke map lainnya
	get_tree().change_scene_to_file( level_path )
	#menunggu animasi fade_in() selesai
	await SceneTransition.fade_in()
	#mematikan pause di scene tree
	get_tree().paused = false
	#memastikan satu frame dijalankan dulu sebelum emit sinyal
	await get_tree().process_frame
	#emit sinyal level_loaded
	level_loaded.emit()
	pass
