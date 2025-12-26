#setup core state_run extends sebagai state
class_name State_Run extends State

#export speed supaya bisa diubah nanti setiap state, jadi misal ada state sneak bakal bisa jadi 30
@export var move_speed = 100.0
#referensi untuk transisi state ke state ini
@onready var idle: State_Idle = $"../Idle"


#saat state dimulai
## What happens when the player enters this state?
func Enter() -> void:
	#saat masuk player akan masuk ke animasi "run"
	player.UpdateAnimation("run")

#saat state keluar
## What happens when the player exits this state?
func Exit() -> void:
	pass


#proses dalam state
## What happens during the _process update in this state?
func Process( _delta : float) -> State:
	#kalau player gak bergerak akan balik ke state_idle
	if player.direction == Vector2.ZERO:
		return idle
	
	#
	player.velocity = player.direction.normalized() * move_speed
	
	if player.SetDirection():
		player.UpdateAnimation("run")
	return null


## What happens during the _physic_process update in this state?
func Physic( _delta : float) -> State:
	return null

## What happens with input events in this state?
func HandleInput( _event: InputEvent) -> State:
	return null
