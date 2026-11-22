extends Control

func _ready() -> void:
	var bg = ColorRect.new()
	bg.color = Color(0.025, 0.12, 0.13)
	bg.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	add_child(bg)
	var center = VBoxContainer.new()
	center.set_anchors_and_offsets_preset(Control.PRESET_CENTER)
	center.position = Vector2(-220, -180)
	center.size = Vector2(440, 360)
	center.add_theme_constant_override("separation", 22)
	add_child(center)
	var title = Label.new()
	title.text = "ISLAND: LOST"
	title.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	title.add_theme_font_size_override("font_size", 42)
	center.add_child(title)
	var subtitle = Label.new()
	subtitle.text = "SOBREVIVA. EXPLORE. ESCAPE."
	subtitle.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	center.add_child(subtitle)
	_add_button(center, "JOGAR", _play)
	_add_button(center, "CONFIGURAÇÕES", _settings)
	_add_button(center, "SAIR", _exit)

func _add_button(parent: VBoxContainer, caption: String, action: Callable) -> void:
	var b = Button.new()
	b.text = caption
	b.custom_minimum_size = Vector2(0, 58)
	b.add_theme_font_size_override("font_size", 22)
	b.pressed.connect(action)
	parent.add_child(b)

func _play() -> void:
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _settings() -> void:
	var dialog = AcceptDialog.new()
	dialog.title = "Configurações"
	dialog.dialog_text = "Protótipo mobile: controles por toque e renderização leve."
	add_child(dialog)
	dialog.popup_centered()

func _exit() -> void:
	get_tree().quit()
