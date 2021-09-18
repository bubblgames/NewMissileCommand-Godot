extends Area2D

class_name Cannon

export (PackedScene) var Missile
export (PackedScene) var Indicator

var ammo
var STARTING_AMM0 = 10
var missiles = []

func _ready():
	missiles.append($Missile10)
	missiles.append($Missile9)
	missiles.append($Missile8)
	missiles.append($Missile7)
	missiles.append($Missile6)
	missiles.append($Missile5)
	missiles.append($Missile4)
	missiles.append($Missile3)
	missiles.append($Missile2)
	missiles.append($Missile1)
	
	reload()
	
func reload():
	ammo = STARTING_AMM0
	for missile in missiles:
		missile.show()
	set_ammo_text()
	
func set_ammo_text():
	if (ammo == 0):
		$AmmoText.text = "OUT"
	elif ammo < 4:
		$AmmoText.text = "LOW"
	else:
		$AmmoText.text = ""
	
func try_shoot(destination, controllerNode):
	if ammo > 0:
		var missile = Missile.instance()
		controllerNode.add_child(missile)
		missile.position = Vector2(position.x, position.y - 20)
		missile.set_destination(destination)
		missile.set_color(Color(0,1,0))
		missile.is_friendly = true
		var indicator = Indicator.instance()
		controllerNode.add_child(indicator)
		indicator.position = destination
		missile.set_indicator(indicator)
		$ShootAudio.play()
		missile.connect("explode", controllerNode, "_on_Explode")
		ammo -= 1
		if ammo == 3:
			$LowAmmoAudio.play()
		set_ammo_text()
		hide_bullet(ammo)
		return missile
	else:
		$EmptyAudio.play()
		
func _on_Cannon_area_entered(area):
	if area.name != "Ground" && area.name != "City":
		ammo = 0
		for i in missiles.size():
			hide_bullet(i)
		set_ammo_text()

func hide_bullet(index):
	missiles[index].hide()
	
func disable_next_missile():
	ammo -= 1
	hide_bullet(ammo)
