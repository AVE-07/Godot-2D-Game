class_name EnemyStateMachine extends Node


#state anak anak FSM akan masuk disini sebagai array, plus datur sama FSM
var states : Array[ EnemyState ]
#state anaknya yang sebelumnya aktif dipake kalo buat rollback state
var prev_state : EnemyState
#state anaknya yang saat ini aktif
var current_state : EnemyState


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	process_mode = Node.PROCESS_MODE_DISABLED
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( delta ):
	change_state( current_state.process( delta ) )
	pass


func _physics_process( delta ):
	change_state( current_state.physics( delta ) )
	pass


func initialize( _enemy : Enemy ) -> void:
	states = []
	
	for c in get_children():
		if c is EnemyState:
			states.append( c )
			
	for s in states:
		s.enemy = _enemy
		s.state_machine = self
		s.init()
	
	if states.size() > 0:
		change_state( states[0] )
		process_mode = Node.PROCESS_MODE_INHERIT


func change_state( new_state : EnemyState ) -> void:
	#ini buat anti noise, jadi kalo state sama ataupun state gak berubah dia bakal stop
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
