extends CharacterBody2D

var speed = 60
var player_chase = false
var player = null

var health = 500
var player_inattack_zone = false
var can_take_damage = true
var is_dead = false

func _physics_process(delta):
	deal_with_damage()
	update_health()
	
	if is_dead:
		return
	
	if player_chase:
		position += (player.position - position)/speed
		
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
		
		$AnimatedSprite2D.play("walk")
	else:
		$AnimatedSprite2D.play("idle")

func _on_detection_area_body_entered(body: Node2D) -> void:
	player = body
	player_chase = true
	
	

func _on_detection_area_body_exited(body: Node2D) -> void:
	player = null
	player_chase = false
	
func enemy():
	pass


func _on_enemy_hitbox_body_entered(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = true


func _on_enemy_hitbox_body_exited(body: Node2D) -> void:
	if body.has_method("player"):
		player_inattack_zone = false

func deal_with_damage():
	if player_inattack_zone and global.player_current_attack == true:
		if can_take_damage == true:
			health = health - 20
			$take_damage_cooldown.start()
			can_take_damage = false
			print("Slime health = ", health)
			if health <= 0 and !is_dead:
				is_dead = true
				var world = get_tree().current_scene
				velocity = Vector2.ZERO

				var anim = $AnimatedSprite2D
				anim.play("death")

				await anim.animation_finished
				get_tree().paused = true
				get_parent().show_you_won()


func _on_take_damage_cooldown_timeout() -> void:
	can_take_damage = true
	
func update_health():
	var healthbar = $healthbar
	healthbar.value = health
	
	if health >= 500:
		healthbar.visible = false
	else:
		healthbar.visible = true
