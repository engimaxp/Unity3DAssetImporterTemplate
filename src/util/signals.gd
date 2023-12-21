extends Node
signal deselect_all_units
signal unit_selected(unit)
signal unit_move_order_start(unit)
#signal unit_move_order_end()
signal unit_deselected(unit)

signal enter_mode_trigger_by(unit)
signal exit_enter_mode(unit)

signal change_to_phase(p)
signal toggle_phase(p,is_start_or_end)
