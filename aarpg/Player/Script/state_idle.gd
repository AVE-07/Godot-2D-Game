#setup core state_idle extends sebagai state
class_name State_Idle extends State

#referensi untuk transisi state ke state ini
@onready var run: State_Run = $"../Run"

#saat state dimulai
## What happens when the player enters this state?
func Enter() -> void:
	#saat state dimulai animasi akan berubah menjadi "idle"
	player.UpdateAnimation("idle")


#saat state keluar, bisa diubah kedepannya
## What happens when the player exits this state?
func Exit() -> void:
	pass


#proses dalam state
## What happens during the _process update in this state?
func Process( _delta : float) -> State:
	#kecepatan = 0, karena idle itu animasi diam
	player.velocity = Vector2.ZERO
	#kalo arah playernya berubah dia bakal transisi ke state_run
	if player.direction != Vector2.ZERO:
		return run
	return null


## What happens during the _physic_process update in this state?
func Physic( _delta : float) -> State:
	return null

## What happens with input events in this state?
func HandleInput( _event: InputEvent) -> State:
	return null
