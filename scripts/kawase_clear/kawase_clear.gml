/* 
    |\__/,|   (`\
  _.|o o  |_   ) )
-(((---(((--------
Cat Judges your code
*/

/// @func kawase_clear(kawase_array)
/// @description Clears all of the kawase surfaces (may not be necessary)
/// @param kawase_array
var _root_array = argument0;
var _iterations = kawase_get_max_iterations(_root_array);

var _i = 0;
repeat(_iterations + 1)
{
	__kawase_check_surface(_root_array[_i]);
	var _current_array = _root_array[_i];
	surface_set_target(_current_array[2]);
	draw_clear_alpha(c_black, 0);
	surface_reset_target();
	   
	++_i;
}