extends Node3D

var hunger := 100.0
var thirst := 100.0
var player: CharacterBody3D
var status_label: Label
var move_vector := Vector2.ZERO

func _ready() -> void:
	_build_island()
	_build_player()
	_build_hud()

func _process(delta: float) -> void:
	hunger = maxf(0.0, hunger - delta * 0.22)
	thirst = maxf(0.0, thirst - delta * 0.38)
	status_label.text = "FOME: %d%%   SEDE: %d%%" % [int(hunger), int(thirst)]

func _physics_process(delta: float) -> void:
	if player == null:
		return
	var direction = Vector3(move_vector.x, 0, move_vector.y)
	if Input.is_key_pressed(KEY_W): direction.z -= 1
	if Input.is_key_pressed(KEY_S): direction.z += 1
	if Input.is_key_pressed(KEY_A): direction.x -= 1
	if Input.is_key_pressed(KEY_D): direction.x += 1
	direction = direction.normalized()
	player.velocity.x = direction.x * 5.0
	player.velocity.z = direction.z * 5.0
	if not player.is_on_floor(): player.velocity.y -= 20.0 * delta
	else: player.velocity.y = -0.1
	player.move_and_slide()

func _build_island() -> void:
	var sun = DirectionalLight3D.new()
	sun.rotation_degrees = Vector3(-55, -25, 0)
	sun.light_energy = 1.4
	add_child(sun)
	var ground = MeshInstance3D.new()
	var mesh = CylinderMesh.new()
	mesh.top_radius = 24
	mesh.bottom_radius = 28
	mesh.height = 2
	ground.mesh = mesh
	ground.position.y = -1.2
	var mat = StandardMaterial3D.new()
	mat.albedo_color = Color(0.16, 0.38, 0.19)
	ground.material_override = mat
	add_child(ground)
	for i in range(22):
		var tree = MeshInstance3D.new()
		var trunk = CylinderMesh.new()
		trunk.top_radius = 0.22
		trunk.bottom_radius = 0.35
		trunk.height = 2.4
		var crown = SphereMesh.new()
		crown.radius = 1.2
		crown.height = 2.4
		var branch = Node3D.new()
		var t = MeshInstance3D.new()
		t.mesh = trunk
		var tm = StandardMaterial3D.new()
		tm.albedo_color = Color(0.28, 0.16, 0.08)
		t.material_override = tm
		branch.add_child(t)
		var c = MeshInstance3D.new()
		c.mesh = crown
		c.position.y = 1.7
		var cm = StandardMaterial3D.new()
		cm.albedo_color = Color(0.08, 0.27, 0.12)
		c.material_override = cm
		branch.add_child(c)
		branch.position = Vector3(sin(i * 8.1) * 17, 0, cos(i * 8.1) * 17)
		add_child(branch)
	var water = MeshInstance3D.new()
	var sea = CylinderMesh.new()
	sea.top_radius = 45
	sea.bottom_radius = 45
	sea.height = 0.2
	water.mesh = sea
	water.position.y = -2.4
	var wm = StandardMaterial3D.new()
	wm.albedo_color = Color(0.02, 0.25, 0.42)
	water.material_override = wm
	add_child(water)

func _build_player() -> void:
	player = CharacterBody3D.new()
	player.position = Vector3(0, 2, 0)
	var body = CollisionShape3D.new()
	var capsule = CapsuleShape3D.new()
	capsule.height = 1.8
	capsule.radius = 0.4
	body.shape = capsule
	player.add_child(body)
	var visual = MeshInstance3D.new()
	var capsule_mesh = CapsuleMesh.new()
	capsule_mesh.height = 1.8
	visual.mesh = capsule_mesh
	var pm = StandardMaterial3D.new()
	pm.albedo_color = Color(0.75, 0.65, 0.42)
	visual.material_override = pm
	player.add_child(visual)
	var camera = Camera3D.new()
	camera.position = Vector3(0, 8, 11)
	camera.rotation_degrees = Vector3(-32, 0, 0)
	camera.current = true
	player.add_child(camera)
	add_child(player)

func _build_hud() -> void:
	var layer = CanvasLayer.new()
	add_child(layer)
	status_label = Label.new()
	status_label.position = Vector2(24, 20)
	status_label.add_theme_font_size_override("font_size", 24)
	layer.add_child(status_label)
	var hint = Label.new()
	hint.text = "WASD / toque: mover  |  Explore a ilha e sobreviva"
	hint.position = Vector2(24, 56)
	layer.add_child(hint)
	var pad = HBoxContainer.new()
	pad.position = Vector2(24, 560)
	pad.add_theme_constant_override("separation", 12)
	layer.add_child(pad)
	for data in [["◀", Vector2(-1, 0)], ["▲", Vector2(0, -1)], ["▼", Vector2(0, 1)], ["▶", Vector2(1, 0)]]:
		var button = TouchScreenButton.new()
		button.visibility_mode = TouchScreenButton.VISIBILITY_ALWAYS
		var shape = RectangleShape2D.new()
		shape.size = Vector2(68, 68)
		button.shape = shape
		button.position = Vector2(0, 0)
		button.action = ""
		var b = Button.new()
		b.text = data[0]
		b.custom_minimum_size = Vector2(68, 68)
		b.button_down.connect(func(): move_vector = data[1])
		b.button_up.connect(func(): move_vector = Vector2.ZERO)
		pad.add_child(b)
	var back = Button.new()
	back.text = "MENU"
	back.position = Vector2(1100, 20)
	back.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/menu.tscn"))
	layer.add_child(back)
	var collect = Button.new()
	collect.text = "BEBER / COMER"
	collect.position = Vector2(1000, 560)
	collect.pressed.connect(func(): hunger = minf(100, hunger + 20); thirst = minf(100, thirst + 20))
	layer.add_child(collect)
