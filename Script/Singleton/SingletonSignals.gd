extends Node

signal save_game()
signal save_to_file()

signal show_dialog()
signal hide_dialog()
signal player_message(iconName: String, textToDisplay:String)
signal peopel_message(iconName: String, textToDisplay:String)

signal load_equiment()
signal show_equipment()
signal hide_equipment()
signal look_at_item(item: Item)

signal show_map()
signal hide_map()
signal change_scene()
signal disabe_loadin_screen()
signal enable_loadin_screen()
