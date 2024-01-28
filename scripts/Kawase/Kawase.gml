// Feather disable all

/// Constructor that returns a struct that handles a Kawase blur.
/// 
///   N.B. You must call the .Destroy() method on the returned struct to avoid memory leaks!
/// 
/// This struct has the following methods:
///   .GetWidth()
///   .GetHeight()
///   .GetMaxIterations()
///   .GetSurface()
///   .Destroy()
///   .Blur([iterations])
///   .DrawDebug(x, y)
/// 
/// @param width
/// @param height
/// @param maxIterations

#macro __KAWASE_VERSION  "2.0.1"
#macro __KAWASE_DATE     "2024-01-28"

show_debug_message("Kawase: Welcome to Kawase by Juju Adams! This is version " + __KAWASE_VERSION + ", " + __KAWASE_DATE);

function Kawase(_width, _height, _maxIterations) constructor
{
    __width         = _width;
    __height        = _height;
    __maxIterations = _maxIterations;
    
    __destroyed = false;
	__surfaceArray = array_create(_maxIterations+1, undefined);

	var _w = __width;
	var _h = __height;
	var _i = 0;
	repeat(__maxIterations + 1)
	{
	    var _struct = {
            __width:       _w,
            __height:      _h,
            __surface:     -1,
            __texelWidth:   1,
            __texelHeight:  1,
        }
        
        __surfaceArray[@ _i] = _struct;
	    __CheckSurface(_struct);
    
	    _w = _w div 2;
	    _h = _h div 2;
	    ++_i;
	}
    
    static Destroy = function()
    {
        if (__destroyed) return;
        __destroyed = true;
        
    	var _i = 0;
    	repeat(array_length(__surfaceArray))
    	{
    	    surface_free(__surfaceArray[_i].__surface);
    	    ++_i;
    	}
    }
    
    static GetWidth = function()
    {
        return __width;
    }
    
    static GetHeight = function()
    {
        return __height;
    }
    
    static GetMaxIterations = function()
    {
        return __maxIterations;
    }
    
    static GetSurface = function()
    {
        return __CheckSurface(__surfaceArray[0]);
    }
    
    static DrawDebug = function(_x, _y)
    {
        if (__destroyed) return;
        
    	var _i = 0;
    	repeat(array_length(__surfaceArray))
    	{
    	    var _struct = __surfaceArray[_i];
    	    draw_surface(_struct.__surface, _x, _y);
            
    	    _x += _struct.__width;
    	    ++_i;
    	}
    }
    
    static Blur = function(_iterations = __maxIterations)
    {
    	static _shd_kawase_down_vTexel = shader_get_uniform(shdKawaseDown, "u_vTexel");
    	static _shd_kawase_up_vTexel   = shader_get_uniform(shdKawaseUp  , "u_vTexel");
    	static _identityMatrix = matrix_build_identity();
        
        if (__destroyed) return;
        
    	_iterations = clamp(_iterations, 0, __maxIterations);

    	var _i = 0;
    	repeat(_iterations + 1)
    	{
    	    __CheckSurface(__surfaceArray[_i]);
    	    ++_i;
    	}

    	var _oldBlendEnable   = gpu_get_blendenable();
    	var _oldTexFilter     = gpu_get_tex_filter();
    	var _oldTexRepeat     = gpu_get_tex_repeat();
    	var _oldShader        = shader_current();
        var _oldBlendmodeSrc  = gpu_get_blendmode_src();
        var _oldBlendmodeDest = gpu_get_blendmode_dest();
    	var _oldMatrixWorld   = matrix_get(matrix_world);

    	gpu_set_blendenable(true);
    	gpu_set_tex_filter(true);
    	gpu_set_tex_repeat(false);
        gpu_set_blendmode_ext(bm_one, bm_zero);
    	matrix_set(matrix_world, _identityMatrix);
    	shader_set(shdKawaseDown);

    	var _i = 1;
    	repeat(_iterations)
    	{
    	    var _prevStruct = __surfaceArray[_i-1];
    	    var _nextStruct = __surfaceArray[_i  ];
    
    	    surface_set_target(_nextStruct.__surface);
    	    shader_set_uniform_f(_shd_kawase_down_vTexel, _prevStruct.__texelWidth, _prevStruct.__texelHeight);
    	    draw_surface_stretched(_prevStruct.__surface, 0, 0, _nextStruct.__width, _nextStruct.__height);
    	    surface_reset_target();
    
    	    ++_i;
    	}

    	shader_set(shdKawaseUp);

    	var _i = _iterations;
    	repeat(_iterations)
    	{
    	    var _prevStruct = __surfaceArray[_i  ];
    	    var _nextStruct = __surfaceArray[_i-1];
    
    	    surface_set_target(_nextStruct.__surface);
    	    shader_set_uniform_f(_shd_kawase_up_vTexel, _prevStruct.__texelWidth, _prevStruct.__texelHeight);
    	    draw_surface_stretched(_prevStruct.__surface, 0, 0, _nextStruct.__width, _nextStruct.__height);
    	    surface_reset_target();
    
    	    --_i;
    	}

    	gpu_set_blendenable(_oldBlendEnable);
    	gpu_set_tex_filter(_oldTexFilter);
    	gpu_set_tex_repeat(_oldTexRepeat);
    	shader_set(_oldShader);
        gpu_set_blendmode_ext(_oldBlendmodeSrc, _oldBlendmodeDest);
    	matrix_set(matrix_world, _oldMatrixWorld);
    }
    
    static __CheckSurface = function(_struct)
    {
        if (__destroyed) return;
        
    	var _width   = _struct.__width;
    	var _height  = _struct.__height;
    	var _surface = _struct.__surface;
        
    	var _newSurface = false;
        
    	if (!surface_exists(_surface))
    	{
    	    _surface = surface_create(_width, _height);
    	    _newSurface = true;
    	}
        
    	if ((surface_get_width(_surface) != _width) || (surface_get_height(_surface) != _height))
    	{
    	    surface_free(_surface);
    	    _surface = surface_create(_width, _height);
    	    _newSurface = true;
    	}
        
    	if (_newSurface)
    	{
    	    _struct.__surface = _surface;
            
    	    var _texture = surface_get_texture(_surface);
    	    _struct.__texelWidth  = 0.5*texture_get_texel_width(_texture);
    	    _struct.__texelHeight = 0.5*texture_get_texel_height(_texture);
    	}
        
    	return _surface;
    }
}