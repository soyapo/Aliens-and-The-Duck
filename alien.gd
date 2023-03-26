extends RigidBody2D

func get_size(s):
	var rect = s.get_global_rect()
	var size = rect.size
	print(size)

func _process(delta):
	get_size($alien)
