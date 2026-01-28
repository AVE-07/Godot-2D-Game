#mendefinisikan class dengan nama EnemyStateMachine yang mewarisi Node
class_name EnemyStateMachine extends Node

#semua state anak(idle dll) disini supaya fsm tau state apa yang tersedia, dan saling mereferensi
var states : Array[ EnemyState ]
#state anaknya yang sebelumnya aktif dipake kalo buat rollback state
var prev_state : EnemyState
#state anaknya yang saat ini aktif
var current_state : EnemyState

#function yang aktrif saat FSM masuk ke scene tree pertma kali
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#FSM tidak diinisialisasi terlebih dahulu, karena current state masih bervalue null
	process_mode = Node.PROCESS_MODE_DISABLED
	pass

#dua function yang akan berperan sebagai saran jika state harus ganti, dan fsm akan menentukan ganti atau tidak 
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( delta ):
	change_state( current_state.process( delta ) )
	pass


func _physics_process( delta ):
	change_state( current_state.physics( delta ) )
	pass

#function untuk inisialisasi state
func initialize( _enemy : Enemy ) -> void:
	#membuat states dengan wadah array kosong
	states = []
	#dari semua anak fsm, fsm akan mencari jika anak tersebut masuk kategori EnemyState maka akan ditaruh 
	#diantrian belakang array states
	for c in get_children():
		if c is EnemyState:
			states.append( c )
			
	#didalam states, states akan meminjam character enemy, lalu state berkomunikasi dengan fsm
	for s in states:
		s.enemy = _enemy
		s.state_machine = self
		s.init()
		
	#jika ukuran states lebih dari 0 maka pakai states index 0 sebagai state awal lalu aktifkan process node
	if states.size() > 0:
		change_state( states[0] )
		process_mode = Node.PROCESS_MODE_INHERIT

#function yang digunakan untuk mengubah suatu states
func change_state( new_state : EnemyState ) -> void:
	#ini buat anti noise, jadi kalo state sama ataupun state gak berubah maka kembalikan value
	if new_state == null || new_state == current_state:
		return
	
	#jika masuk state saat ini, state saat ini keluar
	if current_state:
		current_state.exit()
	
	#current_state jadi prev_state
	prev_state = current_state
	#new_state jadi current_state
	current_state = new_state
	#state saat ini masuk
	current_state.enter()
