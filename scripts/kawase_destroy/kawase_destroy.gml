/// @param kawaseArray

function kawase_destroy(_root_array)
{
	var _i = 0;
	repeat(array_length(_root_array))
	{
	    var _array = _root_array[_i];
	    surface_free(_array[2]);
	    ++_i;
	}
}