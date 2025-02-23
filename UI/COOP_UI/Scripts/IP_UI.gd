extends RUMI_Region


@onready var ip_edit: LineEdit = $Control/Ip_panel/MarginContainer/HBoxContainer/VBoxContainer/VBoxContainer2/LineEdit2



func _on_connect_button_down() -> void:
	COOP.join_game(ip_edit.text)
