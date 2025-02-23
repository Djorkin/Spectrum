extends Resource


@export_category("Настройки")
@export var logging_enabled: bool = true

@export_category("Лимиты")
@export_range(10, 1000, 1) var max_messages_ui: int = 100
@export_range(100, 5000, 1) var max_txt_msg: int = 333
@export_range(1, 50, 1) var max_log_files: int = 5

@export_category("Внешний вид")
@export var default_color: Color = Color.WHITE
@export var warn_color: Color = Color.YELLOW
@export var error_color: Color = Color.RED
@export var say_color: Color = Color.BLUE_VIOLET
