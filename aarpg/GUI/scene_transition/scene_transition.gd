#mewarisi CanvasLayer
extends CanvasLayer
#mereferensikan animation player
@onready var animation_player: AnimationPlayer = $Control/AnimationPlayer

#function animasi fade_out
func fade_out() -> bool:
	#jalankan animasi fade_out
	animation_player.play( "fade_out" )
	#menunggu animasi selesai
	await animation_player.animation_finished
	#kembalikan nilai dengan true
	return true

#function animasi fade_in
func fade_in() -> bool:
	#jalankan animasi fade_in
	animation_player.play( "fade_in" )
	#menunggu animasi selesai
	await animation_player.animation_finished
	#kembalikan nilai dengan true
	return true
