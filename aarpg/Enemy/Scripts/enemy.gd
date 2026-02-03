#mendefinisikan class dengan nama enemy dengan mewarisi CharacterBody2D
class_name Enemy extends CharacterBody2D

#sinyal saat arah musuh berubah, jadi dia akan memberikan sinyal perubahan sesuai arah new_direction
signal direction_changed( new_direction : Vector2 )
#sinyal saat musuh terkena serangan, jadi dia akan memberikan sinyal damaged
signal enemy_damaged( hurt_box : HurtBox )
signal enemy_destroyed( hurt_box : HurtBox )

#4 arah utama, untuk mengunci supaya hanya bisa bergerak kie 4 arah bukan diagonal
const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

#membuat var hp yang bisa diubah didalam inspector karena export
@export var hp : int = 1

#arah utama musuh saat awal, musuh akan mengarah kebawah
var cardinal_direction : Vector2 = Vector2.DOWN
#arah mentah atau logika gerak, bisa nol bisa diagonal dll
var direction : Vector2 = Vector2.ZERO
#sebagai refensi ke player
var player : Player
#untuk status kebal sementara setelah terkana hit
var invulnerable : bool = false

#@onready maksudnya variabel baru diisi setelah node masuk scene, dan bisa diambil child node
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
#ini untuk state_machine seperti animasi idle, walk, run, hit, dll
@onready var state_machine: EnemyStateMachine = $EnemyStateMachine
#ini untuk supaya enemy bisa terkena serangan 
@onready var hit_box: HitBox = $HitBox


#fungsi yang dipanggil sekali saat musuh masuk node
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#state_machine di inisialisasi dengan diarahkan ke musuh
	state_machine.initialize( self )
	#musuh menyimpan referensi player dari PlayerManager
	player = PlayerManager.player
	hit_box.Damaged.connect( _take_damage )
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process( _delta ):
	pass


#untuk pergerakan musuh
func _physics_process( _delta ):
	move_and_slide()


#fungsi untuk menerima arah baru
func set_direction( _new_direction : Vector2 ) -> bool:
	direction = _new_direction
	#kalo character gak gerak, character gak berubah arahnya, menghindari animasi kedap kedip
	if direction == Vector2.ZERO:
		return false
	#konversi vector input ke index 4 arah utama
	# + cardinal_direction * 0.1 buat bias lebih ke arah cardinalnya supaya transisi lebih stabil untuk diagonal
	#angle diubah jadi arah sudut
	#lalu dibagi TAU (360 derajat), dikalikan jumlah arah utama (4), dibulatkan ke index terdekat
	#cardinal_direction*0.1, memberi dorongan kecil, supaya saat hampir diagonal arah tidak bolak balik
	var direction_id : int = int( round( ( 
		direction + cardinal_direction * 0.1 ).angle() / TAU * DIR_4.size() 
		) )
	#arah final diambil dari array arah utama, dengan value direction_id
	var new_dir = DIR_4[ direction_id ]
	
	#kalo new_dir sama dengan arah lama, tidak perlu update
	if new_dir == cardinal_direction:
		return false
	
	#saat nilai new_dir berubah, cardinal_direction akan pakai nilai new_dir sebagai nilai baru
	cardinal_direction = new_dir
	#saat arah berubah kasih pemberitahuan beserta arahnya dari new_dir
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


func _take_damage( hurt_box : HurtBox ) -> void :
	if invulnerable == true:
		return
	hp -= hurt_box.damage
	if hp > 0:
		enemy_damaged.emit( hurt_box )
	else:
		enemy_destroyed.emit( hurt_box )
