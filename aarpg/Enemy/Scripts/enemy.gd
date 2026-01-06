class_name Enemy extends CharacterBody2D


signal direction_changed( new_direction : Vector2 )
signal enemy_damaged()

const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

@export var hp : int = 1

var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var player : Player
var invulnerable : bool = false

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
##
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	state_machine.initialize( self )
	player = PlayerManager.player
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( _delta ):
	pass


func _physics_process( _delta ):
	move_and_slide()


func set_direction( _new_direction : Vector2 ) -> bool:
	direction = _new_direction
	#kalo character gak gerak, character gak berubah arahnya
	if direction == Vector2.ZERO:
		return false
	#konversi vector input ke index 4 arah utama
	# + cardinal_direction * 0.1 buat bias lebih ke arah cardinalnya supaya transisi lebih stabil untuk diagonal
	var direction_id : int = int( round( ( 
		direction + cardinal_direction * 0.1 ).angle() / TAU * DIR_4.size() 
		) )
	var new_dir = DIR_4[ direction_id ]
	
	#kalo new_dir hasilnya tetep sama kayak cardinal_direction berhenti
	if new_dir == cardinal_direction:
		return false
	
	#saat nilai new_dir berubah, cardinal_direction akan pakai nilai new_dir sebagai nilai baru
	cardinal_direction = new_dir
	#saat arah berubah kasih pemberitahuan beserta arahnya
	direction_changed.emit( new_dir )
	return true


func update_animation( state : String ) -> void:
	#.play digunakan untuk jalankan animasi sesuai state sama AnimDirectionnya
	animation_player.play( state + "_" + AnimDirection())
	pass


func AnimDirection() -> String:
	#kalo cardial_direction ke bawah nilai AnimeDirection bakal jadi "down", dst
	if cardinal_direction == Vector2.DOWN:
		return "down"
	elif cardinal_direction == Vector2.LEFT:
		return "left"
	elif cardinal_direction == Vector2.RIGHT:
		return "right"
	else:
		return "up"
