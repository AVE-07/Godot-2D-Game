#memberikan nama class Level dengan mewarisi Node2D
class_name Level extends Node2D

#function yang aktif saat pertama kali masuk tree
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#untuk mengatur posisi y terbawah akan digambar diatas objek yang y teratas
	#contoh player dibelakang pohon (player.y < pohon.y) maka pohon akan menutupi player, dan sebaliknya
	self.y_sort_enabled = true
	#mengubah map menjadi parent dimana player itu childnya
	#hasilnya saat map berubah player inventory, status dll tetap yang berubah hanya map
	PlayerManager.set_as_parent( self )
	LevelManager.level_load_started.connect( _free_level )

#function untuk melepaskan player sebagai anak
func _free_level() -> void:
	#menjalankan func unparent_player di PlayerManager dengan terget diri sendiri
	PlayerManager.unparent_player( self )
	#menghapus node dari scene tree
	queue_free()
