/// @param kawaseArray
/// @param [iterations]

function kawase_blur()
{
	var _root_array = argument[0];
	var _iterations = (argument_count > 1)? argument[1] : undefined;

	if (_iterations == undefined)
	{
	    _iterations = array_length(_root_array) - 1;
	}
	else
	{
	    _iterations = clamp(_iterations, 0, array_length(_root_array) - 1);
	}

	var _i = 0;
	repeat(_iterations + 1)
	{
	    __kawase_check_surface(_root_array[_i]);
	    ++_i;
	}

	var _old_blend_enable   = gpu_get_blendenable();
	var _old_tex_filter     = gpu_get_tex_filter();
	var _old_shader         = shader_current();
    var _old_blendmode_src  = gpu_get_blendmode_src();
    var _old_blendmode_dest = gpu_get_blendmode_dest();

	gpu_set_blendenable(true);
	gpu_set_tex_filter(true);
    gpu_set_blendmode_ext(bm_one, bm_zero);
	shader_set(shd_kawase_down);

	var _i = 1;
	repeat(_iterations)
	{
	    var _prev_array = _root_array[_i-1];
	    var _next_array = _root_array[_i  ];
    
	    surface_set_target(_next_array[2]);
	    shader_set_uniform_f(global.__kawase_down_texel_uniform, _prev_array[3], _prev_array[4]);
	    draw_surface_stretched(_prev_array[2], 0, 0, _next_array[0], _next_array[1]);
	    surface_reset_target();
    
	    ++_i;
	}

	shader_set(shd_kawase_up);

	var _i = _iterations;
	repeat(_iterations)
	{
	    var _prev_array = _root_array[_i  ];
	    var _next_array = _root_array[_i-1];
    
	    surface_set_target(_next_array[2]);
	    shader_set_uniform_f(global.__kawase_up_texel_uniform, _prev_array[3], _prev_array[4]);
	    draw_surface_stretched(_prev_array[2], 0, 0, _next_array[0], _next_array[1]);
	    surface_reset_target();
    
	    --_i;
	}

	gpu_set_blendenable(_old_blend_enable);
	gpu_set_tex_filter(_old_tex_filter);
	shader_set(_old_shader);
    gpu_set_blendmode_ext(_old_blendmode_src, _old_blendmode_dest);
}