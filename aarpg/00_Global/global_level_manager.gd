#global node yang dijadikan autoload, bisa diakses dimanapun dengan LevelManager
extends Node

#menyimpan batas tile map yang sedang aktif
var current_tilemap_bounds : Array[ Vector2 ]
#sinyal yang dikirim saat bounds tilemap berubah
#dengan parameter array[top_left, bottom_right]
signal TileMapBoundsChanged( bounds : Array[ Vector2 ] )

#fungsi yang digunakan saat mengubah tilemap
func ChangeTileMapBounds( bounds : Array[ Vector2 ] ) -> void:
	#saat tilemap berubah dia akan memberi pemberitahuan bahwa bounds berubah
	#seluruh node yang terkoneksi dengan sinyal ini akan mengetahuinya
	current_tilemap_bounds = bounds
	TileMapBoundsChanged.emit( bounds )
	
	
