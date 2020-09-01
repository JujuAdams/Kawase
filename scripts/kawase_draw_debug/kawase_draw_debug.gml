/// @param kawaseArray

var _root_array = argument0;

var _i = 0;
var _x = 0;
repeat(array_length_1d(_root_array))
{
    var _array = _root_array[_i];
    draw_surface(_array[2], _x, 0);
    
    _x += _array[0];
    ++_i;
}