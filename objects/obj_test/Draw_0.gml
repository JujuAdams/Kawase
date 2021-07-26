var _surface = kawase_get_surface(kawase);

surface_set_target(_surface);
draw_clear_alpha(c_black, 0);
draw_sprite(spr_test, 1, 0, 0);
surface_reset_target();

kawase_blur(kawase, round(kawase_get_max_iterations(kawase) * mouse_x / room_width));

draw_surface(_surface, 0, 0);