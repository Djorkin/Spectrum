extends MarginContainer

@onready var language_option_button: OptionButton = $VBoxContainer/ScrollContainer/VBoxContainer/VBox_Container/Lang/VBoxContainer2/LanguageOptionButton
@onready var save_butt: Button = $VBoxContainer/SAVE_RESET/Save
@onready var reset_butt: Button = $VBoxContainer/SAVE_RESET/RES

@onready var UI_Help = UI_Helper.new()

@onready var volume_label: Label = $VBoxContainer/ScrollContainer/VBoxContainer/Audio/Lang/VBoxContainer2/MarginContainer2/Label
@onready var volume_slider: HSlider = $"VBoxContainer/ScrollContainer/VBoxContainer/Audio/Lang/VBoxContainer2/MarginContainer/Volume HSlider"


const LANGUAGE_CODES = ["en", "ru"]

func _ready() -> void:
	load_config_settings()

func load_config_settings():
	var lang_code = SettingsConfig.get_value("gameplay", "lang", "en")
	var index = LANGUAGE_CODES.find(lang_code)
	if index == -1:
		index = 0
		SettingsConfig.set_value("gameplay", "lang", LANGUAGE_CODES[index])
	language_option_button.selected = index
	apply_language(LANGUAGE_CODES[index])


	var volume = SettingsConfig.get_value("gameplay", "volume", 100)
	var volume_db = linear_to_db(volume / 100.0)
	SoundManager.set_volume(volume_db)
	volume_slider.value = volume



func apply_language(lang_code: String):
	match lang_code:
		"en":
			UI_Help.change_language("en", self)
			Logger.log_("Selected language: English")
		"ru":
			UI_Help.change_language("ru", self)
			Logger.log_("Selected language: Русский")
		_:
			Logger.log_("Invalid language code.")

func _on_save_button_down() -> void:
	SettingsConfig.set_value("gameplay", "volume", volume_slider.value)
	SettingsConfig.save_config()
	Logger.log_("Настройки сохранены.")


func _on_res_button_down(section: String = "") -> void:
	if section == "":
		Logger.log_("Сбрасываем все настройки к значениям по умолчанию.")
	else:
		Logger.log_("Сбрасываем настройки для секции: %s" % section)
	SettingsConfig.set_default_config(section)
	SettingsConfig.save_config()
	load_config_settings()


func _on_language_option_button_item_selected(index: int) -> void:
	var lang_code = LANGUAGE_CODES[index]
	SettingsConfig.set_value("gameplay", "lang", lang_code)
	apply_language(lang_code)


func _on_volume_h_slider_value_changed(value: float) -> void:
	volume_label.text = str(value, "%")
	var volume_db = linear_to_db(value / 100.0)
	SoundManager.set_volume(volume_db)
	SettingsConfig.set_value("gameplay", "volume", value)
	Logger.log_("Изменена громкость на: %d" % value)
