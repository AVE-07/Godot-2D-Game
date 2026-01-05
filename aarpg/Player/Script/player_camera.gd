#setup core playercamera inherit dari Camera2D
class_name PlayerCamera extends Camera2D


#dipakai saat node camera masuk scene tree
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#menghubungkan ke sinyal levelmanager dengan fungsi TileMapBoundsChanged
	#fungsi update limit akan mengikuti perubahan yang diberitahu sinyal
	LevelManager.TileMapBoundsChanged.connect( UpdateLimit )
	#langsung pply saat init, juga sebagai safeguard saat sinyal tidak diterima
	UpdateLimit( LevelManager.current_tilemap_bounds )
	pass # Replace with function body.


#fungsi yang membuat kamera stop saat mencapai batas tilemaps
func UpdateLimit( bounds : Array[ Vector2 ] ) -> void:
	#jika bounds kosong, lewati
	if bounds == []:
		return
	#set batas kiri, atas, kanan, bawah sesuai tilemap
	limit_left = int( bounds[0].x )
	limit_top = int( bounds[0].y )
	limit_right = int( bounds[1].x )
	limit_bottom = int( bounds[1].y )
	pass
