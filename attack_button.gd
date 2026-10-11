extends TouchScreenButton

signal attack_pressed

func _ready():
	pressed.connect(_on_attack_pressed)

func _on_attack_pressed():
	attack_pressed.emit()
