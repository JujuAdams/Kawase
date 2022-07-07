/// @param iterationArray

function __kawase_check_surface(_array)
{
	var _width   = _array[0];
	var _height  = _array[1];
	var _surface = _array[2];

	var _new_surface = false;

	if (!surface_exists(_surface))
	{
	    _surface = surface_create(_width, _height);
	    _new_surface = true;
	}

	if ((surface_get_width(_surface) != _width) || (surface_get_height(_surface) != _height))
	{
	    surface_free(_surface);
	    _surface = surface_create(_width, _height);
	    _new_surface = true;
	}

	if (_new_surface)
	{
	    var _texture = surface_get_texture(_surface);
	    _array[@ 2] = _surface;
	    _array[@ 3] = 0.5*texture_get_texel_width(_texture);
	    _array[@ 4] = 0.5*texture_get_texel_height(_texture);
	}

	return _surface;
}



#macro __KAWASE_VERSION  "1.1.1"
#macro __KAWASE_DATE     "2022-07-07"

show_debug_message("Kawase: Welcome to Kawase by @jujuadams! This is version " + __KAWASE_VERSION + ", " + __KAWASE_DATE);