@tool
extends EditorPlugin

var plugin_control

func _enter_tree():
	plugin_control = preload("res://addons/godot_shader_linker_(gsl)/UI/Graph_Editor.tscn").instantiate()
	EditorInterface.get_editor_main_screen().add_child(plugin_control)
	plugin_control.hide()

func _has_main_screen():
	return true

func _make_visible(visible):
	plugin_control.visible = visible

func _get_plugin_name():
	return "Graph Editor"

func _get_plugin_icon():
	return get_editor_interface().get_editor_theme().get_icon("Shader", "EditorIcons")
