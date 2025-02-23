extends RUMI_Region

@onready var control: Control = $Control
@onready var log_label: RichTextLabel = $Control/Panel/VBoxContainer/MarginContainer/Log_label
@onready var line_edit: LineEdit = $Control/Panel/VBoxContainer/VBoxContainer3/PanelContainer/HBoxContainer/LineEdit
@onready var bort: PanelContainer = $Control/Panel/VBoxContainer/Bort

@onready var UI_helper = UI_Helper.new()

var dragging: bool = false
var last_mouse_position: Vector2

func _ready() -> void:
	Logger.connect_ui(log_label)
	reg_commands()
	bort.connect("gui_input", Callable(self, "_on_bort_gui_input"))
	bort.mouse_filter = Control.MOUSE_FILTER_STOP
	Logger.execute_command("demon")

func _on_button_button_down() -> void:
	SoundManager.play_sfx("ui_close")
	self.hide()

func _input(event):
	if event is InputEventKey and event.is_pressed():
		if Input.is_action_just_pressed("logger"):
			if self.visible:
				_on_button_button_down()
				SoundManager.play_sfx("ui_close")
				UI_helper.update_mouse_capture(RUMI.current_region)
			else:
				self.show()
				UI_helper.update_mouse_capture(self)
				line_edit.grab_focus()

func _on_line_edit_text_submitted(new_text: String) -> void:
	Logger.execute_command(new_text)
	line_edit.text = ""

func clr() -> void:
	if log_label != null:
		log_label.text = ""
		Logger.log_messages.clear()

func _on_bort_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				dragging = true
				last_mouse_position = event.global_position
			else:
				dragging = false
	elif event is InputEventMouseMotion and dragging:
		var mouse_delta = event.global_position - last_mouse_position
		control.set_position(control.position + mouse_delta)
		last_mouse_position = event.global_position


func mouse_cap():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func mouse_vis():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func reg_commands():
	Logger.register_command("clr", Callable(self, "clr"))
	Logger.register_command("demon", Callable(self, "demon"))
	Logger.register_command("bruh", Callable(self, "bruh"))
	Logger.register_command("skull", Callable(self, "skull"))
	Logger.register_command("cap", Callable(self, "mouse_cap"))
	Logger.register_command("vis", Callable(self, "mouse_vis"))



func bruh() -> void:
	Logger.log_warn("
⡏⠉⠉⠉⠉⠉⠉⠋⠉⠉⠉⠉⠉⠉⠋⠉⠉⠉⠉⠉⠉⠉⠉⠉⠉⠙⠉⠉⠉⠹
⡇⢸⣿⡟⠛⢿⣷⠀⢸⣿⡟⠛⢿⣷⡄⢸⣿⡇⠀⢸⣿⡇⢸⣿⡇⠀⢸⣿⡇⠀
⡇⢸⣿⣧⣤⣾⠿⠀⢸⣿⣇⣀⣸⡿⠃⢸⣿⡇⠀⢸⣿⡇⢸⣿⣇⣀⣸⣿⡇⠀
⡇⢸⣿⡏⠉⢹⣿⡆⢸⣿⡟⠛⢻⣷⡄⢸⣿⡇⠀⢸⣿⡇⢸⣿⡏⠉⢹⣿⡇⠀
⡇⢸⣿⣧⣤⣼⡿⠃⢸⣿⡇⠀⢸⣿⡇⠸⣿⣧⣤⣼⡿⠁⢸⣿⡇⠀⢸⣿⡇⠀
⣇⣀⣀⣀⣀⣀⣀⣄⣀⣀⣀⣀⣀⣀⣀⣠⣀⡈⠉⣁⣀⣄⣀⣀⣀⣠⣀⣀⣀⣰
", self)

func skull():
	Logger.log_err("
⠄⠄⠄⠄⠄⠄⠄⣀⣠⣤⣤⣤⣤⣀⡀
⠄⠄⠄⠄⣠⣤⢶⣻⣿⣻⣿⣿⣿⣿⣿⣿⣦⣤⣀
⠄⠄⠄⣼⣺⢷⣻⣽⣾⣿⢿⣿⣷⣿⣿⢿⣿⣿⣿⣇
⠄⠠⡍⢾⣺⢽⡳⣻⡺⣽⢝⢗⢯⣻⢽⣻⣿⣿⣿⣿⢿⡄
⠄⡨⣖⢹⠜⢅⢫⢊⢎⠜⢌⠣⢑⠡⣹⡸⣜⣯⣿⢿⣻⣷
⠄⢜⢔⡹⡭⣪⢼⠽⠷⠧⣳⢘⢔⡝⠾⠽⢿⣷⣿⣟⢷⣟
⠄⢸⢘⢼⠿⠟⠁⠄⠄⡀⠄⠃⠑⡌⠄⠄⠈⠙⠿⣷⢽⣻
⠄⢌⠂⠅⠄⠄⠄⠄⠄⠄⡀⣲⣢⢂⠄⠄⠄⠄⠄⠈⣯⠏
⠄⠐⠨⡂⠄⠄⠄⠄⠄⡀⡔⠋⢻⣤⡀⠄⠄⢀⠄⢸⣯⠇
⠄⠈⣕⠝⠒⠄⠄⠒⢉⠪⠄⠄⠄⢿⠜⠑⠢⠠⡒⡺⣿
⠄⠄⠐⠅⠁⡀⠄⠐⢔⠁⠄⠄⠄⢀⢇⢌⠄⠄⠄⠸⠕
⠄⠄⠄⠂⠄⠄⠨⣔⡝⠼⡄⠂⣦⡆⣿⣲⠐⠑⠁
⠄⠄⠄⠄⠄⠄⠄⠃⢫⢛⣙⡊⣜⣏⡝⣝⠆
⠄⠄⠄⠄⠄⠄⠄⠈⠈⠁⠁⠁⠈⠈⠊ ", self)

func demon() -> void:
	Logger.log_say("
⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⠀⣰⠀⣄
⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣎⣴⠂⠀⠀⠀⠀⠀⠀⠀⢹⠀⢹⠀⡏
⠀⠀⠀⠀⠀⠀⠀⣰⣿⣿⣿⣿⣷⠀⠀⠀⠀⠀⠀⠀⠸⣤⣇⡼
⠀⠀⠀⠀⠀⠀⣾⣿⣿⣿⣿⣷⣧⠀⠀⠀⠀⠀⠀⠀⠀⢰⠃
⠀⠀⠀⠀⣀⣴⣿⣿⣿⣿⣿⠿⠃⠀⣀⣀⣠⣤⡤⠶⣿⠁
⠀⠀⠈⠛⢻⣽⢿⣿⣿⣿⣿⣿⣿⡛⠛⠉⠉⠀⠀⠀⡿
⠀⠀⠀⠀⠙⠛⢻⣿⣿⣿⣿⣿⣿⠇⠀⠀⠀⠀⠀⠀⢰⠇
⢴⡇⠀⠀⡴⠊⣿⣿⠁⠘⣿⣿⡇⠀⠀⣀⣤⣴⣶⣾⣷⣄
⢸⠀⠀⣠⠃⣼⡟⢱⠀⣸⣿⣿⣧⣶⣿⣿⣿⡿⠟⡿⢻⣿⣆
⠀⠉⠉⠁⣼⠏⠀⢸⠀⣿⣿⣿⣿⣿⣿⣿⣿⣶⣶⣷⣦⣽⣿⣧⡀⠀⠀⠀⠀⣀
⠀⢤⡶⠾⠃⠀⠀⠀⠉⠛⢿⣿⣿⣿⡿⠿⠟⠛⠉⠟⠉⠛⠛⠿⠿⠷⠶⠾⠟ ", self)
