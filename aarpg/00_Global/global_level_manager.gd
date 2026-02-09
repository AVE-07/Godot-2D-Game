#global node yang dijadikan autoload, bisa diakses dimanapun dengan LevelManager
extends Node

signal level_load_started
signal level_loaded
#sinyal yang dikirim saat bounds tilemap berubah
#dengan parameter array[top_left, bottom_right]
signal TileMapBoundsChanged( bounds : Array[ Vector2 ] )

var target_transition : String
var position_offset : Vector2
#menyimpan batas tile map yang sedang aktif
var current_tilemap_bounds : Array[ Vector2 ]


func _ready() -> void:
	await get_tree().process_frame
	level_loaded.emit()

#fungsi yang digunakan saat mengubah tilemap
func ChangeTileMapBounds( bounds : Array[ Vector2 ] ) -> void:
	#saat tilemap berubah dia akan memberi pemberitahuan bahwa bounds berubah
	#seluruh node yang terkoneksi dengan sinyal ini akan mengetahuinya
	current_tilemap_bounds = bounds
	TileMapBoundsChanged.emit( bounds )


func load_new_level(
	level_path : String,
	_target_transition : String,
	_position_offset : Vector2
) -> void:
	
	get_tree().paused = true
	target_transition = _target_transition
	position_offset = _position_offset
	
	await SceneTransition.fade_out()
	
	level_load_started.emit()
	
	await get_tree().process_frame
	
	get_tree().change_scene_to_file( level_path )
	
	await SceneTransition.fade_in()
	
	get_tree().paused = false
	
	await get_tree().process_frame
	
	level_loaded.emit()
	
	pass
