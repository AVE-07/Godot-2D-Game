#setup core FSM (finite state machine) awal
class_name PlayerStateMachine extends Node

#state anak anak FSM akan masuk disini sebagai array, plus datur sama FSM
var state : Array[ State ]
#state anaknya yang sebelumnya aktif dipake kalo buat rollback state
var prev_state : State
#state anaknya yang saat ini aktif
var current_state : State


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#ini dimasukin disini supaya FSM jangan aktif dulu sebelum di init discript playernya sebagai safe gate 
	process_mode = Node.PROCESS_MODE_DISABLED
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( delta ) -> void:
	#ini dipakai saat player request state dikirim lewat state dan di handle sama FSM
	ChangeState( current_state.Process( delta ) )
	pass
	

func _physics_process( delta ) -> void:
	#sama kayak yang diatas bedanya ini atur fisik, kayak velocity, move_speed, collision dll
	ChangeState( current_state.Physic( delta ) )
	pass


func _unhandled_input( event ):
	#ini yang atur input user, karena walaupun input sama kalo state beda bakalan beda efeknya
	#contoh saat state idle tombol space buat "jump", saat state run tombol space buat "roll"
	ChangeState( current_state.HandleInput( event ) )
	pass

#func untuk mengumpulkan semua state, dan player tau statenya baru FSM jalanin
func Initialize( _player : Player ) -> void:
	#FSM reset semua statenya, supaya saat di init ulang gak terjadi error. buat defensif
	state = []
	
	#ngecek semua node anak di FSM
	for c in get_children():
		#kalau c itu merupakan state
		if c is State:
			#c state bakal masuk array state sebagai state list di FSM
			state.append(c)
	
	#ini ngecek apakah statenya ada di array atau kosong
	if state.size() > 0:
		#state pertama (biasanya idle) akan dijasikan state untuk playernya tanpa perlu inject player satu satu
		state[0].player = _player
		#ini yang ubah dari state lama ke state baru
		ChangeState( state[0] )
		#FSM akan ikut state parent, kalo func initialize aktif baru boleh jalan FSM
		process_mode = Node.PROCESS_MODE_INHERIT

func ChangeState ( new_state : State ) -> void:
	#ini buat anti noise, jadi kalo state sama ataupun state gak berubah dia bakal stop
	if new_state == null || new_state == current_state:
		return
	
	#jika masuk state saat ini, state saat ini keluar
	if current_state:
		current_state.Exit()
	
	#current_state jadi prev_state
	prev_state = current_state
	#new_state jadi current_state
	current_state = new_state
	#state saat ini masuk
	current_state.Enter()
