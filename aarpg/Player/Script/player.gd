#setup core player inherit dari CharacterBody2D
class_name Player extends CharacterBody2D

#mengatur var arah, direction = input mentah(analog, diagonal), cardinal_direction = 4 arah utama
var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
#array direction referensi arah 4 arah utama
const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

#pemanggilan depedency yang lain
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var state_machine: PlayerStateMachine = $StateMachine

#signal saat arah diubah
signal DirectionChange( new_direction : Vector2 )

#dipakai untuk node pertama kali dipakai
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#state_machine bisa memakai value yang ada di player tetapi lewat contract bukan random call
	state_machine.Initialize(self)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	#dipakai untuk baca input dengan nilai -1..1
	#direction.x = Input.get_action_strength("right") - Input.get_action_strength("left")
	#direction.y = Input.get_action_strength("down") - Input.get_action_strength("up")
	#mengatur supaya speed diagonal setara sama speed 4 arah utama, dan membaca input -1..1 (update)
	direction = Vector2(
		Input.get_axis("left","right"),
		Input.get_axis("up", "down")
	).normalized()
	pass


func _physics_process( delta ):
	move_and_slide()


func SetDirection() -> bool:
	#kalo character gak gerak, character gak berubah arahnya
	if direction == Vector2.ZERO:
		return false
	#konversi vector input ke index 4 arah utama
	# + cardinal_direction * 0.1 buat bias lebih ke arah cardinalnya supaya transisi lebih stabil untuk diagonal
	var direction_id : int = int( round( ( direction + cardinal_direction * 0.1 ).angle() / TAU * DIR_4.size() ) )
	var new_dir = DIR_4[ direction_id ]
	
	#kalo new_dir hasilnya tetep sama kayak cardinal_direction berhenti
	if new_dir == cardinal_direction:
		return false
	
	#saat nilai new_dir berubah, cardinal_direction akan pakai nilai new_dir sebagai nilai baru
	cardinal_direction = new_dir
	#saat arah berubah kasih pemberitahuan beserta arahnya
	DirectionChange.emit( new_dir )
	return true


func UpdateAnimation( state : String ) -> void:
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
