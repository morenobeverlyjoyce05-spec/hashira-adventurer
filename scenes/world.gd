extends Node2D

var enemy = preload("res://scenes/enemy.tscn")
var enemies_defeated = 0
const TARGET_KILLS = 30

@onready var game_over_panel = $CanvasLayer2/GameOverPanel
@onready var you_won_panel = $CanvasLayer2/YouWonPanel
@onready var kill_label = $CanvasLayer/Panel/KillLabel
@export var boss_scene: PackedScene
@onready var boss_label = $CanvasLayer/Panel/BossLabel
@onready var battle_music = $BattleMusic
@onready var boss_music = $BossMusic

var boss_spawned = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	boss_label.visible = false
	game_over_panel.visible = false
	you_won_panel.visible = false
	
	game_over_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	you_won_panel.process_mode = Node.PROCESS_MODE_ALWAYS
	
	update_kill_counter()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_spawn_timer_timeout() -> void:
	var areas = [
		$SpawnArea,
		$SpawnArea2,
		$SpawnArea3,
		$SpawnArea4
	]

	for area in areas:
		var new_enemy = enemy.instantiate()

		new_enemy.position = area.position + Vector2(
			randf() * area.size.x,
			randf() * area.size.y
		)

		add_child(new_enemy)

func update_kill_counter():
	kill_label.text = "Slime Defeated: %d/%d" % [enemies_defeated, TARGET_KILLS]

	if enemies_defeated >= TARGET_KILLS and !boss_spawned:
		spawn_boss()
		
func spawn_boss():
	boss_spawned = true

	$SpawnTimer.stop() # Ititigil ang pag-spawn ng normal enemies
	for normal_enemy in get_tree().get_nodes_in_group("normal_enemies"):
		normal_enemy.queue_free()
	battle_music.stop()
	
	boss_music.play()

	var boss = boss_scene.instantiate()
	boss.position = $BossSpawn.position
	add_child(boss)
	
	boss_label.visible = true
	$CanvasLayer/Panel/BossLabelTimer.start()


func _on_boss_label_timer_timeout() -> void:
	boss_label.visible = false
	
func show_game_over():
	game_over_panel.visible = true

func _on_retry_button_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_main_menu_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")

func show_you_won():
	you_won_panel.visible = true
