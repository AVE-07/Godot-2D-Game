#class mewarisi CanvasLayer
extends CanvasLayer

#membuat array untuk semua HeartGUI yang ada
var hearts : Array[ HeartGUI ] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#loop semua child yang ada di HFlowContainer
	for child in $Control/HFlowContainer.get_children():
		#jika child itu HeartGUI
		#masukan kedalam array hearts
		#child dibuat invisible terlebih dulu
		if child is HeartGUI:
			hearts.append( child )
			child.visible = false
	pass 


#function untuk update hp 
func update_hp( _hp : int, _max_hp : int ) -> void:
	#menjalankan function update_max_hp sesuai dengan _max_hp player
	update_max_hp( _max_hp )
	#loop untuk i di dalam _max_hp
	for i in _max_hp:
		#jalankan function update_heart sesuai dengan i dan juga _hp
		update_heart( i, _hp )
		pass
	pass

#function untuk mengubah heart
func update_heart( _index : int, _hp : int ) -> void:
	#_value dideklarasikan dengan int dan clampi
	#clampi menghitung (nilai masukan, min, max)
	#contoh: hp = 6, index 1, 6 - 1 * 2 = 4, karena max hanya 2 maka nilainya 2
	var _value : int = clampi( _hp - _index * 2, 0, 2 )
	#menjalankan stter dengan nilai baru dari _index
	hearts[ _index ].value = _value
	pass


#function untuk mengubah max hp
func update_max_hp( _max_hp : int ) -> void:
	#mendeklarasikan heart_count dengan int dan roundi
	#roundi membuat bulat bilangan decimal
	#karena _max_hp = 6 * 0.5 = 3
	var heart_count : int = roundi( _max_hp * 0.5 )
	#looping untuk setip i di banyaknya array heart
	for i in hearts.size():
		#jika i lebih kecil dari heart_count, maka menampilkan heart
		#jika tidak maka tidak ditampilkan
		if i < heart_count:
			hearts[i].visible = true
		else:
			hearts[i].visible = false
	pass
