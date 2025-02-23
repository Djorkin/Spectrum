extends Node


@warning_ignore("unused_signal")
signal scroll

@onready var log_settings = load("res://Data/Logger_Settings/Logger.tres")
@onready var log_messages: Array = []
@onready var log_txt_msg: Array = []

@onready var label_logger: RichTextLabel
var log_filename: String
var command_registry = {}


func _ready() -> void:
	await get_tree().process_frame
	log_filename = "log/LOG_" + get_current_datetime() + ".txt"
	cleanup_old_logs()
	Logger.register_command("info", Callable(self, "command_info"))
	Logger.register_command("say", Callable(self, "command_say"))

func register_command(command_name: String, callable: Callable) -> void:
	if not command_registry.has(command_name):
		command_registry[command_name] = callable
	else:
		push_error("Команда '" + command_name + "' уже зарегистрирована.")


func execute_command(command: String) -> void:
	command = command.strip_edges()
	if command.is_empty():
		SoundManager.play_sfx("ui_fail")
		log_err("Пустая команда")
		return
	
	var parts = command.split(" ", false, 1)
	
	if parts.is_empty():
		SoundManager.play_sfx("ui_fail")
		log_err("Некорректный формат команды")
		return
	
	var cmd_name = parts[0] if parts.size() >= 1 else ""
	var args: PackedStringArray = []
	
	if parts.size() > 1:
		args = parts[1].split(" ") 
	
	if command_registry.has(cmd_name):
		SoundManager.play_sfx("ui_submit")
		if args.is_empty():
			command_registry[cmd_name].call()
		else:
			command_registry[cmd_name].callv(args)
	else:
		SoundManager.play_sfx("ui_fail")
		log_err("Неизвестная команда: " + cmd_name)


func log_(message: String, caller = self, color: Color = log_settings.default_color): 
	if not log_settings.logging_enabled:
		return
	message = "%s: %s" % [caller.name.to_upper(), str(message)]
	var color_code = "[color=#" + color.to_html() + "]"
	var timestamped_message = get_timestamp() + " " + color_code + message + "[/color]"
	txt_log(timestamped_message)
	
	if log_messages.size() < log_settings.max_messages_ui:
		log_messages.append(timestamped_message)
	else: 
		log_messages.remove_at(0)
		log_messages.append(timestamped_message)
	if label_logger != null:
		update_label()


func log_err(message: String, caller = self):
	log_(message,caller,log_settings.error_color)

func log_warn(message: String, caller = self):
	log_(message,caller,log_settings.warn_color)

func log_say(message: String, caller = self):
	log_(message,caller,log_settings.say_color)

func update_label():
	if label_logger != null:
		label_logger.text = "\n".join(log_messages)
		emit_signal("scroll")

func txt_log(msg):
	msg = str(msg)
	if log_txt_msg.size() < log_settings.max_txt_msg:
		log_txt_msg.append(msg)
	else:
		log_txt_msg.remove_at(0)
		log_txt_msg.append(msg)
	writer(log_txt_msg)

func writer(msg_txt):
	var file = FileAccess.open("res://" + log_filename, FileAccess.WRITE_READ)  
	if file:
		file.seek_end()  
		for msg in msg_txt:
			file.store_string(msg + "\n")  
		file.close()
	else:
		print("Ошибка открытия файла для записи.")


func get_timestamp() -> String:
	var date = Time.get_datetime_string_from_system() 
	return "[" + date + "]"


func get_current_datetime() -> String:
	var current_time = Time.get_datetime_dict_from_system()
	var year = str(current_time.year)
	var month = str(current_time.month).pad_zeros(2) 
	var day = str(current_time.day).pad_zeros(2)
	var hour = str(current_time.hour).pad_zeros(2)
	var minute = str(current_time.minute).pad_zeros(2)
	var second = str(current_time.second).pad_zeros(2)
	return year + "-" + month + "-" + day + "__" + hour + "-" + minute + "-" + second


func connect_ui(log_label_node):
	if log_label_node:
		label_logger = log_label_node
	else:
		push_error("Log_label не найден в текущей сцене.")


func command_info():
	var command_names = "\n".join(command_registry.keys())
	log_("\n" + command_names)


func cleanup_old_logs():
	var dir = DirAccess.open("res://log")
	if dir:
		var files = []
		if dir.list_dir_begin() == OK:
			var file_name = dir.get_next()
			while file_name != "":
				if file_name.ends_with(".txt"):
					files.append(file_name)
				file_name = dir.get_next()
			dir.list_dir_end()
			files.sort()
			if files.size() > log_settings.max_log_files+1:
				for i in range(files.size() - log_settings.max_log_files+1):
					dir.remove("res://log/" + files[i])

func command_say(message: String = "Пусто") -> void:
	Logger.log_("Сообщение: " + message)
