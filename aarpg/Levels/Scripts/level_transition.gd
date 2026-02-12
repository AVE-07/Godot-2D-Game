#@tool berarti bisa jalan di editor bisa ubah side, size, snap to grid dll
@tool
#memberi nama class LevelTransition dengan mewarisi Area2D
class_name LevelTransition extends Area2D

#kategori side yang dapat dipilih dengan 4 arah utama
enum SIDE { LEFT, RIGHT, TOP, BOTTOM }

#mengexport file untuk transition map, dengan memakai *.tscn berarti hanya scene saja yang bisa dipilih
@export_file( "*.tscn" ) var level
#ini untuk target transition ke mapnya, misal dari map a ke map b dengan menargetkan pintu c di map b
@export var target_transition_area : String = "LevelTransition"

#ini category untuk mengatur Area2D untuk pergantian map
@export_category( "Collision Area Settings" )
#@export_range memuat slider di inspector dengan isi (nilai min, nilai max, step/setiap satu klik keatas/kebawah
#hanya nambah sesuai dengan angkanya, dan or_greater berguna untuk
#membuat nilai lebih besar daripada nilai maks jika diperlukan
#membuat variabel size dengan type integer dengan nilai default 2
@export_range( 1, 12, 1, "or_greater" ) var size : int = 2:
	#setter dengan isi value _v
	#dimana size setara dengan _v
	#jalankan fungsi _update_area()
	set( _v ):
		size = _v
		_update_area()
#membuat pilihan side di inspector, dengan SIDE.LEFT adalah nilai defaultnya
@export var side : SIDE = SIDE.LEFT:
	#setter dengan isi value _v
	#dimana side setara dengan _v
	#jalankan fungsi _update_area()
	set( _v ):
		side = _v
		_update_area()
#membuat pilihan snap_to_grid di inspector, dengan type boolean bernilai false(off)
@export var snap_to_grid : bool = false:
	#setter dengan isi value _v
	#jalankan fungsi _snap_to_grid()
	set( _v ):
		_snap_to_grid()

#memanggil referensi collision shape
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#jalankan function _update_area()
	_update_area()
	#jika kode sedang dibuka putuskan function ini
	if Engine.is_editor_hint():
		return
	#buat monitoring bernilai false
	monitoring = false
	#jalankan function _place_player()
	_place_player()
	#menunggu sinyal level_loaded di LevelManager
	await LevelManager.level_loaded
	#buat monitoring bernilai false
	monitoring = true
	#saat player masuk sambungkan ke fungsi _player_entered
	body_entered.connect( _player_entered )
	pass

#function yng aktif saat player masuk
func _player_entered( _p : Node2D ) -> void:
	#menjalankan function load_new_level di LevelManager dengan mengisi value yang sudah ada
	LevelManager.load_new_level( level, target_transition_area, get_offset() )
	pass

#function yang aktif untuk menempatkan player
func _place_player() -> void:
	#mengecek, jika nama target_transition yang ada di LevelManager tidak sama dengan nama sekarang stop func
	if name != LevelManager.target_transition:
		return
	#jalankan function set_player_postion di PlayerManager 
	#dengan value global_position + position_offset di LevelManager
	PlayerManager.set_player_position( global_position + LevelManager.position_offset )

#function untuk mendapatakan koordinat player di map baru
func get_offset() -> Vector2:
	#deklarasikan offset dengan Vector2.ZERO
	var offset : Vector2 = Vector2.ZERO
	#deklarasikan player_pos dengan global_position dari player di PlayerManager
	var player_pos = PlayerManager.player.global_position
	#jika side itu SIDE.LEFT atau SIDE.RIGHT
	#offset untuk nilai y = player_pos untuk nilai y - global_position untuk nilai y
	#offset untuk nilai x = 16
	if side == SIDE.LEFT or side == SIDE.RIGHT:
		offset.y = player_pos.y - global_position.y
		offset.x = 16 
		#jika side itu SIDE.LEFT
		#offset untuk nilai x (16) * -1
		if side == SIDE.LEFT:
			offset.x *= -1
	#offset untuk nilai x = player_pos untuk nilai x - global_position untuk nilai x
	#offset untuk nilai y = 16
	else:
		offset.x = player_pos.x - global_position.x
		offset.y = 16 
		#jika side itu SIDE.TOP
		#offset untuk nilai y (16) * -1
		if side == SIDE.TOP:
			offset.y *= -1
	#kembalikan nilai offset
	return offset

#function untuk mengatur _update_area
func _update_area() -> void:
	#deklarasikan new_rect dengan bentuk 32*32
	var new_rect : Vector2 = Vector2( 32, 32 )
	#deklarasikan posisinya tepat di titik 0,0 (titik plus putih ditengah objek)
	var new_position : Vector2 = Vector2.ZERO
	#jika side itu SIDE.TOP
	#lebar new_rect * size
	#new_position akan menjadi (0,-16) (naik satu tile, dimana satu tile 16px)
	if side == SIDE.TOP:
		new_rect.x *= size
		new_position.y -= 16
	#jika side itu SIDE.BOTTOM
	#lebar new_rect * size
	#new_position akan menjadi (0,16) (turun satu tile, dimana satu tile 16px)
	elif side == SIDE.BOTTOM:
		new_rect.x *= size
		new_position.y += 16
	#jika side itu SIDE.LEFT
	#tinggi new_rect * size
	#new_position akan menjadi (-16,0) (kekiri satu tile, dimana satu tile 16px)
	elif side == SIDE.LEFT:
		new_rect.y *= size
		new_position.x -= 16
	#jika side itu SIDE.RIGHT
	#tinggi new_rect * size
	#new_position akan menjadi (16,0) (kekanan satu tile, dimana satu tile 16px)
	elif side == SIDE.RIGHT:
		new_rect.y *= size
		new_position.x += 16
	#jika collision_shape kosong
	if collision_shape == null:
		#ambil di node CollisionShape2D
		collision_shape = get_node( "CollisionShape2D" )
	#ukuran collision_shape yang baru new_rect
	collision_shape.shape.size = new_rect
	#posisi collision_shape yang baru new_position
	collision_shape.position = new_position

#function untuk menyesuaikan grid
func _snap_to_grid() -> void:
	#rumus untuk membuat tile tetap teratur
	#contoh position.x itu 37, dia akan dibagi 16 hasilnya 2.3 lalu karena round maka akan dibulatkan
	#dengan hasil 2 lalu dikali 16 maka jadi 32(dua tile)
	position.x = round( position.x / 16 ) * 16
	position.y = round( position.y / 16 ) * 16
