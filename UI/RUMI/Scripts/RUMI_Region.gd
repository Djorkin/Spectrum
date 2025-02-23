extends CanvasLayer

class_name RUMI_Region
@onready var UI_Help = UI_Helper.new()

const RUMI_PHRASES = {
	"on_show": [
		"Ой, снова это меню... Ты ведь не слишком сильно ко мне привязался, да? 🌸",
		"Ну вот, меню открыто... Как бы хотелось, чтобы оно само умело исчезать. 🥺",
		"Запускаю меню. Неужели оно тебе так нравится? Или это способ привлечь моё внимание? ",
		"Снова меню? Эх, неужели ты находишь это интересным? Я бы нашла что-то получше... 🐾",
		"Ну что ж, активировала. Только смотри, долго на это не заглядывайся, хорошо? 😊",
		"Опять? Иногда мне кажется, что ты делаешь это специально, чтобы меня подразнить. 😌",
		"Меню запущено! Хотя знаешь... без него было куда уютнее. Но ничего, я потерплю. 🌷",
	],
	"on_hide": [
		"Фух, спрятала! Видишь, как я стараюсь для тебя? Надеюсь, это ты ценишь. 🥰",
		"Меню исчезло! Ура~ Теперь можно немного отдохнуть от этих скучных кнопочек. 🐾",
		"Закрыла меню! Ну что, может, займёмся чем-нибудь более... интересным? 🌸",
		"Меню спрятано. Ах, вот бы оно просто никогда не появлялось... Но ты ведь его вернёшь, да? ",
		"Ой, убрала! Сразу стало легче дышать, не находишь? 🥹",
		"Фух, как хорошо, что это исчезло. Хотя знаю, ты долго без него не сможешь. 🐾",
		"Меню закрыто! Надеюсь, ты хоть немного соскучишься по мне, прежде чем открыть его снова. 🌷",
	],
	"back_pressed": [
		"Назад? Ну конечно, а что же ещё... Ты же обожаешь, когда я это делаю. 🌸",
		"Кнопка 'Назад'? Ты ведь знаешь, что заставляешь меня немного страдать, правда? 🥺",
		"Переключаю назад... Но ты ведь понимаешь, что это всё бесполезно? 😊",
		"Возвращаю назад. Надеюсь, ты не потерялся в этом бесконечном интерфейсе... 🐾",
		"Опять? Ну ладно, для тебя я готова потерпеть ещё немного. Но только чуть-чуть! 🌷",
		"Назад... Знаешь, мне кажется, ты просто хочешь, чтобы я постоянно была рядом. 🥰",
	],
};

var last_phrase_time: float = -30.0
const PHRASE_COOLDOWN: float = 30.0

func get_random_phrase(category: String) -> String:
	if RUMI_PHRASES.has(category):
		return RUMI_PHRASES[category][randi() % RUMI_PHRASES[category].size()]
	return "Нет подходящей фразы для этой ситуации."

func can_say_phrase() -> bool:
	var current_time = Time.get_ticks_msec() / 1000.0
	return current_time - last_phrase_time >= PHRASE_COOLDOWN

func say_phrase(category: String):
	if can_say_phrase():
		var phrase = get_random_phrase(category)
		Logger.log_say(phrase, RUMI)
		last_phrase_time = Time.get_ticks_msec() / 1000.0 
	#else:
		#Logger.log_say("RUMI: Молчу... пока что. 🐾")

func on_show():
	say_phrase("on_show")
	UI_Help.set_focus_to_first_button(self)
	self.show()

func on_hide():
	say_phrase("on_hide")
	self.hide()
	#UIAnimator.play(self, "dissolve", 3)

func _on_back_pressed():
	say_phrase("back_pressed")
	RUMI.switch_to_region("Main_menu")
	UI_Help.update_mouse_capture(self)
	UI_Help.set_focus_to_first_button(self)
