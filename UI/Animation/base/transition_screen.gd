extends CanvasLayer
class_name TransitionScreen

var current_animation: String = ""
var tween: Tween


func capture_screen() -> void:
	if not is_inside_tree():
		await tree_entered
	
	var img: Image = get_viewport().get_texture().get_image()
	
	var texture := ImageTexture.create_from_image(img)
	$TextureRect.texture = texture
	$TextureRect.show()


func play_animation(anim_name: String, duration: float = 0.5) -> void:
	current_animation = anim_name
	var color_rect: ColorRect = $ColorRect

	match anim_name:
		"fade_in":
			await capture_screen()
			color_rect.color = Color.BLACK
			color_rect.modulate.a = 0.0
			tween = create_tween()
			tween.tween_property(color_rect, "modulate:a", 1.0, duration/2)
			Logger.log_("fade_in")
		"fade_out":
			color_rect.color = Color.BLACK
			tween = create_tween()
			tween.tween_property(color_rect, "modulate:a", 0.0, duration/2)
			Logger.log_("fade_out")
		"dissolve":
			color_rect.material = load("res://Data/Mat_UI/dissolve.tres")
			tween = create_tween()
			tween.tween_method(_update_dissolve, 0.0, 1.0, duration)

	await tween.finished
	queue_free()

func _update_dissolve(value: float) -> void:
	$ColorRect.material.set_shader_parameter("progress", value)
