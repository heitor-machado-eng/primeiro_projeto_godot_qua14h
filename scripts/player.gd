extends CharacterBody2D

const JUMP_FORCE = -300.0
 
var is_jumping := false

@onready var animation := $anim as AnimatedSprite2D
@export var base_speed: float = 200.0
var SPEED: float

var direction
var speed_timer: Timer

func _ready() -> void:
	SPEED = base_speed
	
	speed_timer = Timer.new()
	speed_timer.one_shot = true
	speed_timer.timeout.connect(_on_speed_timer_timeout)
	add_child(speed_timer)
	

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE
		is_jumping = true
		
	elif is_on_floor():
		is_jumping = false
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		animation.scale.x = direction
		#if !is_jumping:
			#animation.play("run")
	#elif is_jumping:
		#animation.play("jump")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		animation.play("idle")
		
	_set_state()
	move_and_slide()
	
func _set_state():
	var state = "idle"
	
	if !is_on_floor():
		state = "jump"
		
	elif direction != 0:
		state = "run"
		
	if animation.animation != state:
		animation.play(state)
	
func aumentar_speed(valor: float, duracao: float):
	SPEED = base_speed + valor
	print("🚀 Speed aumentada para:", SPEED)
	speed_timer.start(duracao)

func _on_speed_timer_timeout():
	SPEED = base_speed
	print("⏳ Speed voltou para:", SPEED)
	
	
