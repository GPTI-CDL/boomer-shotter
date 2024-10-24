extends CharacterBody3D

@export var move_speed = 2.0
@export var atack_range = 2.0

@onready var jogador : CharacterBody3D = get_tree().get_first_node_in_group("jogador")
var morto = false

func _physics_process(delta):
	if morto:
		return
	if jogador == null:
		return
		
	var dir = jogador.global_position - global_position
	dir.y = 0.0
	dir = dir.normalized()
	velocity = dir * move_speed
	move_and_slide() 
	matar_jogador()

func matar_jogador():
	var dist_jogador = global_position.distance_to(jogador.global_position)
	if dist_jogador > atack_range:
		return
	var linha_de_visao = Vector3.UP * 1.5
	var query = PhysicsRayQueryParameters3D.create(global_position+linha_de_visao, jogador.global_position+linha_de_visao, 1)
	var resultado = get_world_3d().direct_space_state.intersect_ray(query)
	if resultado.is_empty():
		jogador.morte()
	
func morte():
	morto = true
	$CollisionShape3D.disabled = true
	$MeshInstance3D.visible = false
