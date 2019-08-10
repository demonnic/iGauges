-- Big thanks to Jamie W. (Delra) for putting the initial concept together. I just
-- took what they gave me and made it follow the Geyser patterns and used some lesser
-- known Geyser utilities to make it a bit more flexible.

demonnic = demonnic or {}
demonnic.iGauge = demonnic.iGauge or Geyser.Container:new({
  name = "demonnic.iGaugeClass",
	value = 100,
	fillcolor = 'firebrick', --default to a darkish red fill color
	emptycolor = 'black', --default to a black background
	bartype = 'bar', 
	orientation = "horizontal" --only have horizontal but I wanna see if I can figure out vertical.
})

function demonnic.iGauge:setType(bartype)
  self.bartype = bartype
	self.front:setStyleSheet([[
	  border-image: url(]]..getMudletHomeDir()..'/@PKGNAME@/'..self.bartype..[[.png);
	]])
end		
		
function demonnic.iGauge:update(value, foreGround, backGround)
	value = (value < 2 and value) or value/100
	if foreGround then self.fillcolor = foreGround end
	if backGround then self.emptycolor = backGround end
	local fgr,fgg,fgb = Geyser.Color.parse(self.fillcolor)
	local bgr,bgg,bgb = Geyser.Color.parse(self.emptycolor)
	local fgc = table.concat({fgr, fgg, fgb}, ', ')
	local bgc = table.concat({bgr, bgg, bgb}, ', ')
	value = tonumber(value)
	local valm = value-0.02
	local valp = value+0.02
	self.back:setStyleSheet(string.format('background-color: qlineargradient(spread:pad, x1:0, y1:0, x2:1, y2:0, stop:0 rgba(%s,255), stop:%.2f rgba(%s, 255), stop:%.2f rgba(%s,255), stop:1 rgba(%s,255))', fgc, valm, fgc, valp, bgc, bgc))
end

demonnic.iGauge.parent = Geyser.Container

function demonnic.iGauge:new(cons, container)
	cons = cons or {}
	cons.type = cons.type or "iGauge"
	local me = self.parent:new(cons, container)
	setmetatable(me, self)
	self.__index = self
		
	me.back = Geyser.Label:new({
		name = me.name ..'_back',
		x = 0, y = 0,
		width = '100%', 
		height = '100%',
	}, me)
	me.front = Geyser.Label:new({
		name = me.name ..'_front', 
		x = 0, y = 0,
		width = '100%', 
		height = '100%',
	}, me.back)  	
	me:setType(me.bartype)
	me:update(me.value, me.fillcolor, me.emptycolor)
	return me
end
