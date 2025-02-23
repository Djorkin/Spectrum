extends MarginContainer

@onready var screen_mode: OptionButton = $VBoxContainer2/ScrollContainer/VBoxContainer/Main_Box/Window_Mode_Box/VBoxContainer2/Screen_Mode
@onready var resolution: OptionButton = $VBoxContainer2/ScrollContainer/VBoxContainer/Main_Box/Res_Box/VBoxContainer2/Resolution
@onready var res_render: HSlider = $VBoxContainer2/ScrollContainer/VBoxContainer/Main_Box/Res_Box2/VBoxContainer2/MarginContainer/scale_res
@onready var display_filter_mode: OptionButton = $VBoxContainer2/ScrollContainer/VBoxContainer/Main_Box/Display_filter/VBoxContainer2/VBoxContainer2/Filter
@onready var v_sync: OptionButton = $"VBoxContainer2/ScrollContainer/VBoxContainer/Main_Box/V_sync_Box/VBoxContainer2/VBoxContainer2/V-Sync"
@onready var fxaa: OptionButton = $VBoxContainer2/ScrollContainer/VBoxContainer/Main_Box/FXAA_BOX/VBoxContainer2/VBoxContainer2/FXAA
@onready var msaa: OptionButton = $VBoxContainer2/ScrollContainer/VBoxContainer/Main_Box/MSAA_BOX2/VBoxContainer2/VBoxContainer2/MSAA
@onready var shadow_resolution: OptionButton = $"VBoxContainer2/ScrollContainer/VBoxContainer/Main_Box/Shadow_BOX/VBoxContainer2/VBoxContainer2/Shadow Resolution"
@onready var shadow_filtering: OptionButton = $"VBoxContainer2/ScrollContainer/VBoxContainer/Main_Box/Shadow_BOX2/VBoxContainer2/VBoxContainer2/Shadow Filtering"
@onready var resolution_label: Label = $"../../../../../Res_label"


func _ready() -> void:
	load_settings()
	apply_graphics_settings()


func load_settings() -> void:
	screen_mode.select(SettingsConfig.get_value("graphics", "screen_mode_index"))
	resolution.select(SettingsConfig.get_value("graphics", "resolution_index"))
	res_render.value = SettingsConfig.get_value("graphics", "scale_resolution")
	display_filter_mode.select(SettingsConfig.get_value("graphics", "display_filter_mode_index"))
	v_sync.select(SettingsConfig.get_value("graphics", "v_sync_index"))
	fxaa.select(SettingsConfig.get_value("graphics", "fxaa_index"))
	msaa.select(SettingsConfig.get_value("graphics", "msaa_index"))
	shadow_resolution.select(SettingsConfig.get_value("graphics", "shadow_resolution_index"))
	shadow_filtering.select(SettingsConfig.get_value("graphics", "shadow_filtering_index"))


func apply_graphics_settings() -> void:
	var resolution_sizes = [
		Vector2(640, 480),
		Vector2(800, 600),
		Vector2(1280, 720),
		Vector2(1680, 1050),
		Vector2(1920, 1080)
	]

	match SettingsConfig.get_value("graphics", "screen_mode_index"):
		0: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		1: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
		2: DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)

	DisplayServer.window_set_size(resolution_sizes[SettingsConfig.get_value("graphics", "resolution_index")])

	match SettingsConfig.get_value("graphics", "display_filter_mode_index"):
		0: get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_BILINEAR
		1: get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR 
		2: get_viewport().scaling_3d_mode = Viewport.SCALING_3D_MODE_FSR2

	match SettingsConfig.get_value("graphics", "v_sync_index"):
		0: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		1: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
		2: DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ADAPTIVE)

	match SettingsConfig.get_value("graphics", "fxaa_index"):
		0: get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_DISABLED
		1: get_viewport().screen_space_aa = Viewport.SCREEN_SPACE_AA_FXAA

	match SettingsConfig.get_value("graphics", "msaa_index"):
		0: get_viewport().msaa_3d = Viewport.MSAA_DISABLED
		1: get_viewport().msaa_3d = Viewport.MSAA_2X
		2: get_viewport().msaa_3d = Viewport.MSAA_4X
		3: get_viewport().msaa_3d = Viewport.MSAA_8X

	match SettingsConfig.get_value("graphics", "shadow_resolution_index"):
		0: 
			RenderingServer.directional_shadow_atlas_set_size(1024, true)
			get_viewport().positional_shadow_atlas_size = 1024
		1: 
			RenderingServer.directional_shadow_atlas_set_size(2048, true)
			get_viewport().positional_shadow_atlas_size = 2048
		2: 
			RenderingServer.directional_shadow_atlas_set_size(4096, true)
			get_viewport().positional_shadow_atlas_size = 4096
		3:
			RenderingServer.directional_shadow_atlas_set_size(8192, true)
			get_viewport().positional_shadow_atlas_size = 8192
		4:
			RenderingServer.directional_shadow_atlas_set_size(16384, true)
			get_viewport().positional_shadow_atlas_size = 16384

	match SettingsConfig.get_value("graphics", "shadow_filtering_index"):
		0: 
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_VERY_LOW)
		1: 
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_LOW)
		2: 
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_MEDIUM)
		3: 
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_HIGH)
		4: 
			RenderingServer.directional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)
			RenderingServer.positional_soft_shadow_filter_set_quality(RenderingServer.SHADOW_QUALITY_SOFT_ULTRA)


func _on_save_button_down() -> void:
	SettingsConfig.save_config()
	Logger.log_("Настройки сохранены.")


func _on_res_button_down() -> void:
	SettingsConfig.set_default_config("graphics")
	load_settings()
	apply_graphics_settings()
	Logger.log_("Настройки сброшены к значениям по умолчанию.")


func _on_screen_mode_item_selected(index: int) -> void:
	SettingsConfig.set_value("graphics", "screen_mode_index", index)
	apply_graphics_settings()

func _on_resolution_item_selected(index: int) -> void:
	SettingsConfig.set_value("graphics", "resolution_index", index)
	apply_graphics_settings()

func _on_scale_res_value_changed(value: float) -> void:
	var min_res = Vector2(1024, 576) 
	var max_res = Vector2(3840, 2160)  

	var normalized_value = (value - 0.5) / (2 - 0.5)
	var target_resolution = min_res.lerp(max_res, normalized_value)

	get_viewport().scaling_3d_scale = target_resolution.x / get_viewport().size.x
	SettingsConfig.set_value("graphics", "scale_resolution", value)
	update_resolution_label()

func update_resolution_label() -> void:
	var viewport_render_size = get_viewport().size * get_viewport().scaling_3d_scale
	resolution_label.text = "3D viewport resolution: %d × %d (%d%%)" \
			% [viewport_render_size.x, viewport_render_size.y, round(get_viewport().scaling_3d_scale * 100)]


func _on_filter_item_selected(index: int) -> void:
	SettingsConfig.set_value("graphics", "display_filter_mode_index", index)
	apply_graphics_settings()


func _on_v_sync_item_selected(index: int) -> void:
	SettingsConfig.set_value("graphics", "v_sync_index", index)
	apply_graphics_settings()


func _on_fxaa_item_selected(index: int) -> void:
	SettingsConfig.set_value("graphics", "fxaa_index", index)
	apply_graphics_settings()


func _on_msaa_item_selected(index: int) -> void:
	SettingsConfig.set_value("graphics", "msaa_index", index)
	apply_graphics_settings()


func _on_shadow_resolution_item_selected(index: int) -> void:
	SettingsConfig.set_value("graphics", "shadow_resolution_index", index)
	apply_graphics_settings()


func _on_shadow_filtering_item_selected(index: int) -> void:
	SettingsConfig.set_value("graphics", "shadow_filtering_index", index)
	apply_graphics_settings()


func _on_very_low_button_down() -> void:
	SettingsConfig.set_value("graphics", "display_filter_mode_index", 0)
	SettingsConfig.set_value("graphics", "fxaa_index", 0)
	SettingsConfig.set_value("graphics", "msaa_index", 0)
	SettingsConfig.set_value("graphics", "shadow_resolution_index", 0)
	SettingsConfig.set_value("graphics", "shadow_filtering_index", 0)
	apply_graphics_settings()
	load_settings()

func _on_low_button_down() -> void:
	SettingsConfig.set_value("graphics", "display_filter_mode_index", 1)
	SettingsConfig.set_value("graphics", "fxaa_index", 1)
	SettingsConfig.set_value("graphics", "msaa_index", 0)
	SettingsConfig.set_value("graphics", "shadow_resolution_index", 1)
	SettingsConfig.set_value("graphics", "shadow_filtering_index", 1)
	apply_graphics_settings()
	load_settings()

func _on_mid_button_down() -> void:
	SettingsConfig.set_value("graphics", "display_filter_mode_index", 1)
	SettingsConfig.set_value("graphics", "fxaa_index", 1)
	SettingsConfig.set_value("graphics", "msaa_index", 1)
	SettingsConfig.set_value("graphics", "shadow_resolution_index", 2)
	SettingsConfig.set_value("graphics", "shadow_filtering_index", 2)
	apply_graphics_settings()
	load_settings()

func _on_hi_button_down() -> void:
	SettingsConfig.set_value("graphics", "display_filter_mode_index", 1)
	SettingsConfig.set_value("graphics", "fxaa_index", 1)
	SettingsConfig.set_value("graphics", "msaa_index", 2)
	SettingsConfig.set_value("graphics", "shadow_resolution_index", 3)
	SettingsConfig.set_value("graphics", "shadow_filtering_index", 3)
	apply_graphics_settings()
	load_settings()


func _on_ultra_button_down() -> void:
	SettingsConfig.set_value("graphics", "display_filter_mode_index", 2)
	SettingsConfig.set_value("graphics", "fxaa_index", 1)
	SettingsConfig.set_value("graphics", "msaa_index", 3)
	SettingsConfig.set_value("graphics", "shadow_resolution_index", 4)
	SettingsConfig.set_value("graphics", "shadow_filtering_index", 4)
	apply_graphics_settings()
	load_settings()
