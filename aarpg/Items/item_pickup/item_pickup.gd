#menajalankan script didalam editor godot agar perubahan property terlihat langsung
@tool
#memberi nama class ItemPickup dengan mewarisi Node2D
class_name ItemPickup extends CharacterBody2D

#membuat export untuk ItemData dengan setter yang akan di sambungkan ke function _set_item_data
@export var item_data : ItemData :
	set = _set_item_data

#membuat referensi untuk Area2D untuk mengecek collision
@onready var area_2d: Area2D = $Area2D
#membuat referensi untuk Sprite2D untuk sprite
@onready var sprite_2d: Sprite2D = $Sprite2D
#membuat referensi untuk AudioStreamPlayer2D untuk audio
@onready var audio_stream_player_2d: AudioStreamPlayer2D = $AudioStreamPlayer2D

#function yang aktif saat node dipanggil untuk pertama kali
func _ready() -> void:
	#menjalankan function _update_texture()
	_update_texture()
	#jika proses bukan debugging atau gameplay, hentikan function
	if Engine.is_editor_hint():
		return
	#saat body_entered ke dalam Area2D sambungkan signal dan jalankan function _on_body_entered
	area_2d.body_entered.connect( _on_body_entered )


func _physics_process(delta: float) -> void:
	var collision_info = move_and_collide( velocity * delta )
	if collision_info:
		velocity = velocity.bounce( collision_info.get_normal() )
	velocity -= velocity * delta * 4


#function yang jalan saat body_entered Area2D dengan paramater b
func _on_body_entered( b ) -> void:
	#jika b adalah player
	if b is Player:
		#jika item_data
		if item_data:
			#jika INVENTORY_DATA menjalankan function add_item dengan parameter item_data
			#di PlayerManager dan bernilai benar
			if PlayerManager.INVENTORY_DATA.add_item( item_data ) == true:
				#jalankan function item_picked_up()
				item_picked_up()
	pass

#function yang aktif saat item diambil
func item_picked_up() -> void:
	#saat body_entered ke dalam Area2D putuskan signal dari function _on_body_entered
	area_2d.body_entered.disconnect( _on_body_entered )
	#menjalankan audio_stream_player_2d
	audio_stream_player_2d.play()
	#sembunyikan tampilan
	visible = false
	#tunggu sampai audio di audio_stream_player_2d selesai
	await audio_stream_player_2d.finished
	#hapus node item dari scene
	queue_free()
	pass

#function yang aktif untuk mengubah data item dengan parameter value dengan type ItemData
func _set_item_data( value : ItemData ) -> void:
	#menjadikan value sebagai item_data
	item_data = value
	#jalankan function _update_texture()
	_update_texture()
	pass

#function yang aktif saat texture berubah
func _update_texture() -> void:
	#jika item_data dan sprite_2d
	if item_data and sprite_2d:
		#item_data di texture akan diubah menjadi sprite_2d di texture
		sprite_2d.texture = item_data.texture
	pass
