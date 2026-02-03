#setup core player inherit dari CharacterBody2D
class_name Player extends CharacterBody2D

#signal saat arah diubah
signal DirectionChange( new_direction : Vector2 )
signal player_damaged( hurt_box : HurtBox )

#mengatur var arah, direction = input mentah(analog, diagonal), cardinal_direction = 4 arah utama
var cardinal_direction : Vector2 = Vector2.DOWN
var direction : Vector2 = Vector2.ZERO
var invulnerable : bool = false
var hp : int = 6
var max_hp : int = 6

#array direction referensi arah 4 arah utama
const DIR_4 = [ Vector2.RIGHT, Vector2.DOWN, Vector2.LEFT, Vector2.UP ]

#pemanggilan depedency yang lain
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var effect_anim_player: AnimationPlayer = $EffectAnimPlayer
@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var hit_box: HitBox = $HitBox
@onready var state_machine: PlayerStateMachine = $StateMachine

#dipakai untuk node pertama kali dipakai
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	PlayerManager.player = self
	#state_machine bisa memakai value yang ada di player tetapi lewat contract bukan random call
	state_machine.Initialize( self )
	hit_box.Damaged.connect( _take_damage )
	update_hp( 99 )
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


func _take_damage( hurt_box : HurtBox ) -> void:
	if invulnerable == true:
		return
	update_hp( -hurt_box.damage )
	if hp < 0:
		player_damaged.emit( hurt_box )
	else:
		player_damaged.emit( hurt_box )
		update_hp( 99 )
	pass


func update_hp( delta : int ) -> void:
	hp = clampi( hp + delta, 0, max_hp )
	pass


func make_invulnerable( _duration : float = 1.0 ) -> void:
	invulnerable = true
	hit_box.monitoring = false
	
	await get_tree().create_timer( _duration ).timeout
	
	invulnerable = false
	hit_box.monitoring = true
	pass
