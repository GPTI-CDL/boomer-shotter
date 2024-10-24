extends Area3D
@export var municao = 30
@onready var jogador : CharacterBody3D = get_tree().get_first_node_in_group("jogador")


func _on_body_entered(body: Node3D) -> void:
	jogador.cartucho += 30 
