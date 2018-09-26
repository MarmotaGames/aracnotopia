extends Node2D
var pontos
var comprimento = 200 
var init = false
var ancora 

func _draw():
	if $"/root/Root/Spider".grudando == true:
#		draw_line($"/root/Root/Spider".bunda_position, ancora, Color(255, 255, 255), 2)
		var first = true
		var vAnt
		if pontos:
			for v in pontos:
				if first:
					vAnt = v
					first = false
				else:
					draw_line(vAnt, v, Color(255, 255, 255), 2)
					vAnt = v	

func _process(delta):
	if $"/root/Root/Spider".grudando == true:
		
		if not init:
			ancora = $"/root/Root/Spider".bunda_position
			init = true
		update()
		
		if Input.is_action_pressed("aga"):
			pontos = catenary(ancora, $"/root/Root/Spider".bunda_position, comprimento)
		

				
				
				
#	var l = 90
#	var p = 80
#	var q = 30
#	var u = 100
#	var w = 50
#	if p>u:
#		p = u
#		q = w
#		u = p
#		w = q
#	var h=u-p
#	var v=w-q
#	var a = pow(((2*h)/a*sinh(0.5*a)),2)-pow(l,2)-pow(v,2)
#	var b = cosh(a*(1-b))-cosh(a*b)-a*v/h
func a(s, h, d):
	var i=0
	var tempResult = 1.0
	var result = float(sqrt(pow(s,2) - pow(h,2)))
	var numerador = 2.0
	d = float(d)
	while i <= 500:
		
		var fx = sinh(d/numerador) * 2 * tempResult  - result
		var dFxA = 2 * sinh(d/(2 * tempResult)) 
		var dFxB = (d * cosh(d/(2 * tempResult)) / tempResult)
		var dFx = dFxA - dFxB
		if (dFx == 0): 
			i = 501
		else:
			tempResult -= fx/dFx
			numerador = 2 * tempResult
		i += 1
	return result
	
func catenary(a, b, l):
	var v = b.y - a.y
	var h = b.x - a.x
	var aA = a(l, h, 3)
	
	var arraia = []
	var i = 0
	var iX = a.x
	while iX < b.x:
		arraia[i] = Vector2(iX, y(iX, aA))
		iX += 0.5
		i += 1
	return arraia
		
func y(x, a):
	return a * cosh(x/a)
	