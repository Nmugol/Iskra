extends Node

@warning_ignore("unused_signal")
signal save_game()

@warning_ignore("unused_signal")
signal save_to_file()

@warning_ignore("unused_signal")
signal show_dialog()

@warning_ignore("unused_signal")
signal hide_dialog()

@warning_ignore("unused_signal")
signal player_message(iconName: String, textToDisplay: String, increase_stage_phase: bool)

@warning_ignore("unused_signal")
signal people_message(iconName: String, textToDisplay: String, increase_stage_phase: bool)

@warning_ignore("unused_signal")
signal load_equipment()

@warning_ignore("unused_signal")
signal show_equipment()

@warning_ignore("unused_signal")
signal hide_equipment()

@warning_ignore("unused_signal")
signal look_at_item(item: Item)

@warning_ignore("unused_signal")
signal show_map()

@warning_ignore("unused_signal")
signal hide_map()

@warning_ignore("unused_signal")
signal change_scene()

@warning_ignore("unused_signal")
signal disable_loading_screen()

@warning_ignore("unused_signal")
signal enable_loading_screen()


@warning_ignore("unused_signal")
signal show_settings_in_game()

@warning_ignore("unused_signal")
signal hide_settings_in_game()

@warning_ignore("unused_signal")
signal show_ui()

@warning_ignore("unused_signal")
signal update_distance()

@warning_ignore("unused_signal")
signal delete_save()

@warning_ignore("unused_signal")
signal mouse_above_item(area: State.Cursors_above)

@warning_ignore("unused_signal")
signal mouse_off_item()

@warning_ignore("unused_signal")
signal cart_game_timer_on()

@warning_ignore("unused_signal")
signal cart_game_timer_off()

@warning_ignore("unused_signal")
signal cart_go()

@warning_ignore("unused_signal")
signal load_cart_game()

@warning_ignore("unused_signal")
signal finish_cart_game()

@warning_ignore("unused_signal")
signal reparent_cart()

@warning_ignore("unused_signal")
signal set_cart_pos(pos: Vector2) 

@warning_ignore("unused_signal")
signal get_cart(cart: Cart)

@warning_ignore("unused_signal")
signal set_cursor(cursor_name: State.Cursors)

@warning_ignore("unused_signal")
signal reset_cursor()

@warning_ignore("unused_signal")
signal reset_look_at_item()

@warning_ignore("unused_signal")
signal rotate_symbol(rotate_to_left: bool)

@warning_ignore("unused_signal")
signal symbol_move_on_x_axis(left: bool)

@warning_ignore("unused_signal")
signal symbol_move_on_y_axis(up: bool)

@warning_ignore("unused_signal")
signal stop_moving_and_rotate_symbol()

@warning_ignore("unused_signal")
signal symbol_on_target()

@warning_ignore("unused_signal")
signal symbol_not_on_target()

@warning_ignore("unused_signal")
signal reset_symbol()

@warning_ignore("unused_signal")
signal move_player_to_point(point: Vector2)

@warning_ignore("unused_signal")
signal disable_stop_point()

@warning_ignore("unused_signal")
signal player_in_stop_point(pos: Vector2)

@warning_ignore("unused_signal")
signal move_patrol_to_point(patrol_id: String, pos: Vector2)

@warning_ignore("unused_signal")
signal patrol_in_stop_point(patrol_id: String, pos: Vector2)

@warning_ignore("unused_signal")
signal patrol_left_point(patrol_id: String, pos: Vector2)

@warning_ignore("unused_signal")
signal reset_level()

@warning_ignore("unused_signal")
signal next_level()

@warning_ignore("unused_signal")
signal set_player_pos(pos: Vector2)

@warning_ignore("unused_signal")
signal disable_all_stop_points

@warning_ignore("unused_signal")
signal finish_patrol_game()

@warning_ignore("unused_signal")
signal play_sound(audio_type: State.AudioType, audio_stream: AudioStream, pitch_scale: float, volume_db: float)

@warning_ignore("unused_signal")
signal remove_items_from_scene( items:State.Cursors_above)

@warning_ignore("unused_signal")
signal remove_all_items_from_scene()

@warning_ignore("unused_signal")
signal change_info_panel_visibility(visible: bool)

@warning_ignore("unused_signal")
signal change_info_panel_text(text: String)

@warning_ignore("unused_signal")
signal stop_play_sound( type: State.AudioType)

@warning_ignore("unused_signal")
signal increase_cart_stage()

@warning_ignore("unused_signal")
signal move_stone(vector: Vector2, stone: int)

@warning_ignore("unused_signal")
signal stone_not_moving(stone_id: int)

@warning_ignore("unused_signal")
signal finish_stone_min_game()

@warning_ignore("unused_signal")
signal simon_button_is_pressed(id:int)

@warning_ignore("unused_signal")
signal show_location_button(name: State.Locations)

@warning_ignore("unused_signal")
signal tile_rotated(tile_position: Vector2i)

@warning_ignore("unused_signal")
signal play_day_screen()

@warning_ignore("unused_signal")
signal achieved_update(type: State.AchievedType)

@warning_ignore("unused_signal")
signal  finish_simon_mini_game()