/// @param kawaseArray

var _root_array = argument0;

var _i = 0;
repeat(array_length_1d(_root_array))
{
    var _array = _root_array[_i];
    surface_free(_array[2]);
    ++_i;
}