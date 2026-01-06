class_name EnemyStateWonder extends EnemyState


@export var anim_name : String = "walk"
@export var wonder_speed : float = 20.0

@export_category( "AI" )
@export var state_animation_duration : float = 0.5
@export var state_animation_cycle_min : int = 1
@export var state_animation_cycle_max : int = 3
@export var next_state : EnemyState

var _timer : float = 0.0
var _direction : Vector2


## What happens when we Initialize this state?
func init() -> void:
	pass


## What happens when the enemy enters this state?
func enter() -> void:
	_timer = randf_range( state_animation_cycle_min, state_animation_cycle_max ) * state_animation_duration
	var rand = randf_range( 0, 3 )
	_direction = enemy.DIR_4[ rand ]
	enemy.velocity = _direction * wonder_speed
	enemy.set_direction( _direction )
	enemy.update_animation( anim_name )
	pass


## What happens when the enemy exits this state?
func exit() -> void:
	pass


## What happens during the _process update in this state?
func process( _delta: float ) -> EnemyState:
	_timer -= _delta
	if _timer < 0:
		return next_state
	return null


## What happens during the _physics_process update in this state?
func physics( _delta: float ) -> EnemyState:
	return null
