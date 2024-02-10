extends Node2D

# 画面の中央.
const CENTER_X = 1024.0 / 2
const CENTER_Y = 600.0 / 2

@onready var _camera = $MainCamera

@onready var _bg_back = $BgLayer/BgBack
@onready var _bg_sky = $BgLayer/BgSky

@onready var _main_layer = $MainLayer
@onready var _shot_layer = $ShotLayer
@onready var _particle_layer = $ParticleLayer
@onready var _hdr = $WorldEnvironment

@onready var _change_spr = $UILayer/ChangeSprButton
@onready var _change_spr_txt = $UILayer/ChangeSprButton/Label
@onready var _scatter_btn = $UILayer/ScatterButton
@onready var _scatter_txt = $UILayer/ScatterButton/Label
@onready var _scatter_range = $UILayer/ScatterRange
@onready var _scatter_range_txt = $UILayer/ScatterRange/Label
@onready var _offset_btn = $UILayer/OffsetButton
@onready var _offset_txt = $UILayer/OffsetButton/Label
@onready var _particle_btn = $UILayer/ParticleButton
@onready var _particle_txt = $UILayer/ParticleButton/Label
@onready var _camshake_btn = $UILayer/CameraShakeButton
@onready var _camshake_txt = $UILayer/CameraShakeButton/Label
@onready var _hitshake_btn = $UILayer/HitShakeButton
@onready var _hitshake_txt = $UILayer/HitShakeButton/Label
@onready var _knockback_btn = $UILayer/KnockBackButton
@onready var _knockback_txt = $UILayer/KnockBackButton/Label
@onready var _hitslow_btn = $UILayer/HitSlowButton
@onready var _hitslow_txt = $UILayer/HitSlowButton/Label
@onready var _hitslowspeed_rate = $UILayer/HitSlowRate
@onready var _hitslowspeed_rate_txt = $UILayer/HitSlowRate/Label
@onready var _blur_btn = $UILayer/BlurButton
@onready var _blur_txt = $UILayer/BlurButton/Label
@onready var _trail_btn = $UILayer/TrailButton
@onready var _trail_txt = $UILayer/TrailButton/Label
@onready var _hdr_btn = $UILayer/HDRButton
@onready var _hdr_txt = $UILayer/HDRButton/Label

var _ofs_u = 0.0

func _ready() -> void:
	var layers = {
		"main": _main_layer,
		"shot": _shot_layer,
		"particle": _particle_layer,
	}
	Common.setup(layers)

func _process(delta: float) -> void:
	
	# UVオフセット値をシェーダーに渡す
	_ofs_u += delta
	_bg_back.material.set_shader_parameter("ofs_uv", Vector2(_ofs_u * 0.1, 0.0))
	_bg_sky.material.set_shader_parameter("ofs_uv", Vector2(_ofs_u * 0.05, 0.0))
		
	if _change_spr.button_pressed:
		Common.set_change_spr(true)
		_change_spr_txt.modulate = Color.WHITE
	else:
		Common.set_change_spr(false)
		_change_spr_txt.modulate = Color.DIM_GRAY

	if _scatter_btn.button_pressed:
		Common.set_scatter(true)
		_scatter_txt.modulate = Color.WHITE
		_scatter_range_txt.modulate = Color.WHITE
	else:
		Common.set_scatter(false)
		_scatter_txt.modulate = Color.DIM_GRAY
		_scatter_range_txt.modulate = Color.DIM_GRAY
	
	var rng = _scatter_range.value
	Common.set_scatter_range(rng)
	_scatter_range_txt.text = "範囲 ±%d"%rng

	if _offset_btn.button_pressed:
		Common.set_offset(true)
		_offset_txt.modulate = Color.WHITE
	else:
		Common.set_offset(false)
		_offset_txt.modulate = Color.DIM_GRAY

	if _particle_btn.button_pressed:
		Common.set_particle(true)
		_particle_txt.modulate = Color.WHITE
	else:
		Common.set_particle(false)
		_particle_txt.modulate = Color.DIM_GRAY

	if _camshake_btn.button_pressed:
		Common.set_screen_shake(true)
		_camshake_txt.modulate = Color.WHITE
	else:
		Common.set_screen_shake(false)
		_camshake_txt.modulate = Color.DIM_GRAY

	if _hitshake_btn.button_pressed:
		Common.set_enemy_shake(true)
		_hitshake_txt.modulate = Color.WHITE
	else:
		Common.set_enemy_shake(false)
		_hitshake_txt.modulate = Color.DIM_GRAY
	
	if _knockback_btn.button_pressed:
		Common.set_knock_back(true)
		_knockback_txt.modulate = Color.WHITE
	else:
		Common.set_knock_back(false)
		_knockback_txt.modulate = Color.DIM_GRAY
	
	if _hitslow_btn.button_pressed:
		Common.set_hitslow(true)
		_hitslow_txt.modulate = Color.WHITE
		_hitslowspeed_rate_txt.modulate = Color.WHITE
	else:
		Common.set_hitslow(false)
		_hitslow_txt.modulate = Color.DIM_GRAY
		_hitslowspeed_rate_txt.modulate = Color.DIM_GRAY
	
	var speed_rate = _hitslowspeed_rate.value
	Common.set_hitslow_rate(speed_rate)
	_hitslowspeed_rate_txt.text = "速度 x %d%%"%speed_rate
	
	if _blur_btn.button_pressed:
		Common.set_blur(true)
		_blur_txt.modulate = Color.WHITE
	else:
		Common.set_blur(false)
		_blur_txt.modulate = Color.DIM_GRAY
	
	if _trail_btn.button_pressed:
		Common.set_trail(true)
		_trail_txt.modulate = Color.WHITE
	else:
		Common.set_trail(false)
		_trail_txt.modulate = Color.DIM_GRAY
	
	if _hdr_btn.button_pressed:
		_hdr.environment.glow_enabled = true
		_hdr_txt.modulate = Color.WHITE
		_bg_back.visible = false
	else:
		_hdr.environment.glow_enabled = false
		_hdr_txt.modulate = Color.DIM_GRAY
		_bg_back.visible = true
		
	_update_screen_shake(delta)
	Common.update_hitslow(delta)

func _update_screen_shake(delta:float) -> void:
	Common.update_screen_shake(delta)
	var rate = Common.get_screen_shake_rate()
	var v = 8.0 * rate
	var h = 2.0 * rate
	_camera.offset.x = randf_range(-v, v)
	_camera.offset.y = randf_range(-h, h)
