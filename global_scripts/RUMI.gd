extends CanvasLayer

# 🥲 Добро пожаловать в милый, но раздражающий мир UI через RUMI 🥲
# Этот синглтон управляет всеми UI-регионами, чтобы ты больше не тратил время
# на скрытие и показ UI вручную. Надеюсь, это спасёт тебя от UI-ада.

@export var default_region: String = "Main_menu"

var current_region: Node = null
var overlay_region: Node = null


@onready var UI_Help = UI_Helper.new()

var regions: Dictionary = {}

func init(Main_Node: Node):
	for child in Main_Node.get_children():
		regions[child.name] = child
		child.visible = false
	
	# Переключаемся на регион по умолчанию (и молимся, чтобы он существовал)
	if regions.has(default_region):
		switch_to_region(default_region)
	else:
		Logger.log_err("Регион по умолчанию '%s' не найден!" % default_region, self)
	Logger.log_say("Ох, опять работа с UI", self)

# params: Словарь с параметрами для передачи в on_show() нового региона
@rpc("any_peer","call_local","reliable")
func switch_to_region(region_name: String, params: Dictionary = {},):
	#await UIAnimator.play(self, "fade_in", 1)
	
	if current_region:
		current_region.visible = false
		if current_region.has_method("on_hide"):
			current_region.on_hide()
	
	if regions.has(region_name):
		current_region = regions[region_name]
		current_region.visible = true
		if current_region.has_method("on_show"):
			if current_region.get_method_argument_count("on_show") > 0:
				current_region.on_show(params)
			else:
				current_region.on_show()
	else:
		Logger.log_err("Регион '%s' не найден! Может, добавишь его?" % region_name, self)


func overlay_ui(region_name: String, params: Dictionary = {}):
	if overlay_region:
		Logger.log_warn("У тебя уже есть активный overlay '%s'. Сначала убери его! 😤" % overlay_region.name, self)
		return
	
	if regions.has(region_name):
		overlay_region = regions[region_name]
		overlay_region.visible = true
		overlay_region.set_layer(self.get_layer() + 1)  # Повышаем layer
		if overlay_region.has_method("on_show"):
			if overlay_region.get_method_argument_count("on_show") > 0:
				overlay_region.on_show(params)
			else:
				overlay_region.on_show()
		Logger.log_warn("Добавила наложение '%s'. Неужели тебе мало одного UI? 😩" % region_name, self)
	else:
		Logger.log_err("Регион '%s' для наложения не найден. Ты точно всё сделал правильно? 😕" % region_name, self)


func hide_overlay_ui():
	if overlay_region:
		if overlay_region.has_method("on_hide"):
			overlay_region.on_hide()
			UI_Help.set_focus_to_first_button(current_region)
		overlay_region.visible = false
		
		overlay_region.set_layer(self.get_layer())
		Logger.log_say("Убрала overlay '%s'. Надеюсь, больше он не понадобится. 🫠" % overlay_region.name, self)
		overlay_region = null
	else:
		Logger.log_warn("Никакого overlay нет! Зачем ты это вызываешь? 🤨", self)


func has_active_overlay() -> bool:
	return overlay_region != null

# 🛠 Примеры использования:
# 1. Переключиться на регион "Lobby_UI" без параметров:
#    RUMI.switch_to_region("Lobby_UI")
#
# 2. Переключиться на "Settings" и передать параметры:
#    RUMI.switch_to_region("Settings", {"volume": 50, "lang": "ru"})
#
# 3. Если ты добавил новый регион, убедись, что его имя соответствует имени узла!

# 🍬 Дополнительные плюшки:
# - Добавь к своим регионам методы `on_show(params)` и `on_hide()`:
#   - `on_show(params)` вызывается при активации региона, чтобы выполнить
#     специфичную логику, например, обновить текст или загрузить данные.
#   - `on_hide()` вызывается при скрытии региона, чтобы сохранить состояние
#     или прекратить ненужные процессы.
#
# - Если ты забываешь добавлять регионы, RUMI будет на тебя жаловаться. 
#   Но разве ты можешь её винить? Она просто хочет порядок. 😌
