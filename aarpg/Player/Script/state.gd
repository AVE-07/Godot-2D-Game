#setup state ini yang ngatur kontrak antara player dan FSM
class_name State extends Node

#ini biar semua state ngeakses player sama tanpa perlu tulis ulang deklarasi
## Store a reference to the player that this State belongs to
static var player : Player

#ini sengaja dikosongin karena script ini cuman kontrak aja
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


#ini func bakal kepake saat FSM mau masuk ke player
## What happens when the player enters this state?
func Enter() -> void:
	pass


#ini func bakal kepake saat FSM sudah keluar dari player
## What happens when the player exits this state?
func Exit() -> void:
	pass


#ini func untuk process di FSM
## What happens during the _process update in this state?
func Process( _delta : float) -> State:
	return null


#ini func buat physic_process di FSM
## What happens during the _physic_process update in this state?
func Physic( _delta : float) -> State:
	return null


#ini func yang ngehandle apa yang di input user
## What happens with input events in this state?
func HandleInput( _event: InputEvent) -> State:
	return null
