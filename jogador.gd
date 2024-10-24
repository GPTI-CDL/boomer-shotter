extends CharacterBody3D

@onready  var animacao2D = $CanvasLayer/GunBase/AnimatedSprite2D
@onready var ray = $RayCast3D

const SPEED = 5.0
const mouse_senci = 0.5

var pode_atirar = true
var morto = false
var bala = 0
var cartucho = 0
var result = 0
@export var max_bala = 6

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	animacao2D.animation_finished.connect(anicacao_atirar_realizada)
	$CanvasLayer/telaDeMorte/Panel/Button.button_up.connect(resetar)
func _input(event):
	if morto:
		return
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_senci

func _process(delta):
	if Input.is_action_just_pressed("sair"):
		get_tree().quit()
	if Input.is_action_just_pressed("recarregar"):
		recarregar()
	if morto:
		return
	if Input.is_action_just_pressed("atirar") and bala > 0:
		bala -= 1
		atirar()
		
	#if bala == 0: #Aplicar quando tiver a animação de carregar
	#	recarregar()
		
	$cartucho/Panel/Label.text = str(bala) + "/" + str(cartucho) 
func _physics_process(delta: float) -> void:
	if morto:
		return
	var input_dir := Input.get_vector("mov_esq", "move_dir", "move_cima", "move_baixo")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func recarregar():
	if cartucho > 0 and bala <= max_bala:
		result = max_bala - bala
		cartucho -= result
		bala += result
func atirar():
	if !pode_atirar:
		return 
	pode_atirar = false
	animacao2D.play("atirando")
	if ray.is_colliding() and  ray.get_collider().has_method('morte'):
		ray.get_collider().morte()
		
func anicacao_atirar_realizada():
	pode_atirar = true

func resetar():
	get_tree().reload_current_scene()
	
func morte():
	morto = true
	$CanvasLayer/telaDeMorte.show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
