#class mewarisi CanvasLayer
extends CanvasLayer

#membuat signal untuk memberi lihat atau menghilangkan menu pause
signal shown
signal hidden

#membuat referensi untuk audio, save, load dan deskripsi item
@onready var audio_stream_player: AudioStreamPlayer = $Control/AudioStreamPlayer
@onready var button_save: Button = $Control/HBoxContainer/Button_save
@onready var button_load: Button = $Control/HBoxContainer/Button_load
@onready var item_description: Label = $Control/ItemDescription

#membuat var is_paused bertipe boolean dengan default false
var is_paused : bool = false


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#menjalankan function hide_pause_menu()
	hide_pause_menu()
	#saat button_save ditekan hubungkan dengan function _on_save_pressed
	button_save.pressed.connect( _on_save_pressed )
	#saat button_load ditekan hubungkan dengan function _on_load_pressed
	button_load.pressed.connect( _on_load_pressed )
	pass # Replace with function body.

#function yang aktif untuk input global contoh (ESC / pause)
func _unhandled_input(event: InputEvent) -> void:
	#jika event saat ini menekan tombol pause (ESC)
	if event.is_action_pressed( "pause" ):
		#jika is_paused itu bernilai false
		if is_paused == false:
			#jalankan function show_pause_menu()
			show_pause_menu()
		#selain itu
		else:
			#jalankan function hide_pause_menu()
			hide_pause_menu()
		#bagian untuk memutus ke input luar
		#contoh x untuk tombol enter dan buka menu
		#tanpa code ini saat player save dia secara bersamaan akan membuka menu
		get_viewport().set_input_as_handled()

#function untuk menampilkan menu pause
func show_pause_menu() -> void:
	#membuat seluruh tree dalam suatu scene menjadi mode pause
	get_tree().paused = true
	#membuat tampilan terlihat
	visible = true
	#membuat is_paused berubah menjadi nilai true
	is_paused = true
	#mengeluarkan sinyal shown
	shown.emit()

#function untuk menyembunyikan menu pause
func hide_pause_menu() -> void:
	#membuat seluruh tree dalam suatu scene menjadi mode normal
	get_tree().paused = false
	#membuat tampilan tidak terlihat
	visible = false
	#membuat is_paused berubah menjadi nilai false
	is_paused = false
	#mengeluarkan sinyal hidden
	hidden.emit()

#function saat tombol save ditekan
func _on_save_pressed() -> void:
	#jika nilai is_paused bernilai false
	if is_paused == false:
		#batalkan function untuk aktif
		return
	#menjalankan function save_game() di SaveManager
	SaveManager.save_game()
	#jalankan function hide_pause_menu()
	hide_pause_menu()
	pass

#function saat tombol loa ditekan
func _on_load_pressed() -> void:
	#jika nilai is_paused bernilai false
	if is_paused == false:
		#batalkan function untuk aktif
		return
	#menjalankan function load_game() di SaveManager
	SaveManager.load_game()
	#tunggu sinyal level_load_started di LevelManager
	await LevelManager.level_load_started
	#jalankan function hide_pause_menu()
	hide_pause_menu()
	pass

#function untuk update item deskripsi dengan parameter new_text bertipe string
func update_item_description( new_text : String ) -> void:
	#membuat new_text menjadi text di item_description
	item_description.text = new_text

#function untuk memainkan audio dengan parameter audio bertipe AudioStream
func play_audio( audio : AudioStream ) -> void:
	#membuat audio menjadi stream di audio_stream_player
	audio_stream_player.stream = audio
	#menjalankan audio_stream_player
	audio_stream_player.play()
