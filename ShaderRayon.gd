tool
extends Sprite


func _process(delta):
	# print(texture.get_size()*scale)
	self.material.set_shader_param("texture_size", texture.get_size()*scale)
	pass
