#node yang akan ditempel disetiap tilemap baru
#setup core leveltilemap inherit dari TileMap
class_name LevelTileMap extends TileMap


#saat node tilemap masuk secne tree fungsi ini aktif
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#saat node siap, update bounds(batasan) tilemap ke LevelManager
	#jadi LevelManager tahu batasan dari tilemap ini untuk kamera atau logic lain
	LevelManager.ChangeTileMapBounds( GetTileMapBounds() )
	pass # Replace with function body.

#fungsi untuk mengukur batasan tilemap ini
func GetTileMapBounds() -> Array[ Vector2 ]:
	#menyiapkan var bounds dengan array[ top_left, bottom_right ]
	var bounds : Array[ Vector2 ] = []
	#get_used_rect() akan memberikan rect2 dari area tile yang dipake
	#dikali rendering_quadrant_size biar dapat posisi dunianya (world coordinat)
	bounds.append(
		#posisi top-left
		Vector2( get_used_rect().position * rendering_quadrant_size )
	)
	bounds.append(
		#posisi bottom-right
		Vector2( get_used_rect().end * rendering_quadrant_size )
	)
	#mengembalikan bound keluar
	return bounds
