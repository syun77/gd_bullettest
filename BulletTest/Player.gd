extends Node2D

const ShotObj = preload("res://Shot.tscn")

var _shot_timer = 0.0
var _shot_cnt = 0

func _physics_process(delta: float) -> void:
	delta *= Common.get_hitslow_rate()
	_shot_timer += delta
	
	var v = Vector2()
	if Input.is_action_pressed("ui_left"):
		v.x += -1
	if Input.is_action_pressed("ui_up"):
		v.y += -1
	if Input.is_action_pressed("ui_right"):
		v.x += 1
	if Input.is_action_pressed("ui_down"):
		v.y += 1
	
	v = v.normalized()
	position += 300 * v * delta

	_shot_cnt += 1
	var shot_rate = _get_shot_rate()
	if _shot_cnt % shot_rate == 0:
		_shot()

func _shot() -> void:
	var deg = 90
	
	if Common.is_scatter():
		var rng = Common.get_scatter_range()
		deg += rand_range(-rng, rng)
	
	var spd = 1500
	var shot = ShotObj.instance()
	shot.position = position
	
	if _shot_cnt%4 == 0:
		if Common.is_offset():
			shot.position.y -= 12
	
	shot.set_velocity(deg, spd)
	Common.get_layer("shot").add_child(shot)
	if Common.is_screen_shake():
		# ショットガン
		for i in range(12):
			var shot2 = ShotObj.instance()
			shot2.position = position
			var deg2 = deg + rand_range(-10, 10)
			var speed = spd * rand_range(0.8, 1.0)
			shot2.set_velocity(deg2, speed)
			Common.get_layer("shot").add_child(shot2)
		# カメラ揺れ開始.
		Common.start_screen_shake()

func _get_shot_rate() -> int:
	var ret = 2
	
	if Common.is_screen_shake() == true:
		ret = 2 * 32

	var rate = Common.get_hitslow_rate()
	if rate > 0:
		ret = int(ret / rate)
	else:
		ret = 9999999

	return ret
