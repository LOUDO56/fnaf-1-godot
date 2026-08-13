class_name Libs extends Node2D

static func is_mouse_in_window(viewport: Viewport) -> bool:
	return viewport.get_visible_rect().has_point(viewport.get_mouse_position())
