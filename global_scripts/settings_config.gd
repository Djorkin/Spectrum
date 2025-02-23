extends Node

const CONFIG_FILE_PATH = "user://config.ini"
var config = ConfigFile.new()

func _ready():
	if not load_config():
		Logger.log_("Ошибка при загрузке конфигурации. Используются значения по умолчанию.")
		set_default_config()
		save_config()


func load_config() -> bool:
	var error = config.load(CONFIG_FILE_PATH)
	if error != OK:
		printerr("Ошибка загрузки конфигурации: ", error)
		return false
	else:
		Logger.log_("Конфигурационный файл загружен успешно.")
		return true

func save_config() -> bool:
	var error = config.save(CONFIG_FILE_PATH)
	if error != OK:
		printerr("Ошибка сохранения конфигурации: ", error)
		return false
	else:
		Logger.log_("Конфигурация сохранена успешно.")
		return true

func set_default_config(section: String = ""):
	match section:
		"graphics":
			config.set_value("graphics", "screen_mode_index", 0)
			config.set_value("graphics", "resolution_index", 4)
			config.set_value("graphics", "scale_resolution", 1.0)
			config.set_value("graphics", "display_filter_mode_index", 1)
			config.set_value("graphics", "v_sync_index", 1)
			config.set_value("graphics", "fxaa_index", 1)
			config.set_value("graphics", "msaa_index", 1)
			config.set_value("graphics", "shadow_resolution_index", 2)
			config.set_value("graphics", "shadow_filtering_index", 2)
		"gameplay":
			config.set_value("gameplay", "lang", "en")
			config.set_value("gameplay", "volume", 100)
		"controls":
			config.set_value("controls", "Forward", KEY_W)
			config.set_value("controls", "Back", KEY_S)
			config.set_value("controls", "Left", KEY_A)
			config.set_value("controls", "Right", KEY_D)
			config.set_value("controls", "Jump", KEY_SPACE)
			config.set_value("controls", "m_sense", 0.1)
		"net":
			config.set_value("net", "Name", null)
		"":
			set_default_config("graphics")
			set_default_config("gameplay")
			set_default_config("controls")
			set_default_config("net")

func get_value(section: String, key: String, default_value = null):
	if not config.has_section_key(section, key):
		set_value(section, key, default_value)
		return default_value
	return config.get_value(section, key, default_value)

func set_value(section: String, key: String, value):
	config.set_value(section, key, value)
