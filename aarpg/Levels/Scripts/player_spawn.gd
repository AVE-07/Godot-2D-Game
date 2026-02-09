#class ini mewariskan Node2D dan punya posisi
extends Node2D

#saat scene masuk tree
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#menyembunyikan spawner
	visible = false
	#jika player belum pernah muncul
	if PlayerManager.player_spawned == false:
		#memberikan posisi player ke PlayerManager
		PlayerManager.set_player_position( global_position )
		#player akan muncul
		PlayerManager.player_spawned = true
