extends CharacterBody2D

@export var speed := 300.0
const JUMP_VELOCITY := -400.0

enum State {
	IDLE,
	WALK,
	JUMP
}

var state = State.IDLE

var jumps = 0
var max_jumps = 2

# Última direção pressionada
var direction := 0


func _physics_process(delta):

	# Gravidade
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		jumps = 0

	# -------------------------
	# Sistema de prioridade do último input
	# -------------------------

	if Input.is_action_just_pressed("left"):
		direction = -1

	if Input.is_action_just_pressed("right"):
		direction = 1

	if Input.is_action_just_released("left"):
		if Input.is_action_pressed("right"):
			direction = 1
		elif !Input.is_action_pressed("left"):
			direction = 0

	if Input.is_action_just_released("right"):
		if Input.is_action_pressed("left"):
			direction = -1
		elif !Input.is_action_pressed("right"):
			direction = 0

	# -------------------------
	# Pulo
	# -------------------------

	if Input.is_action_just_pressed("jump") and jumps < max_jumps:
		velocity.y = JUMP_VELOCITY
		jumps += 1
		set_state(State.JUMP)

	# -------------------------
	# Estados
	# -------------------------

	if is_on_floor():
		if direction == 0:
			set_state(State.IDLE)
		else:
			set_state(State.WALK)
	else:
		set_state(State.JUMP)

	# -------------------------
	# Executa estado
	# -------------------------

	match state:
		State.IDLE:
			idle_state()

		State.WALK:
			walk_state()

		State.JUMP:
			jump_state()

	move_and_slide()


func set_state(new_state):
	if state == new_state:
		return

	state = new_state


func idle_state():
	velocity.x = move_toward(velocity.x, 0, speed)


func walk_state():
	velocity.x = direction * speed


func jump_state():
	velocity.x = direction * speed
