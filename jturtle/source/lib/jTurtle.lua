--[[

jTurtle API

v2

By The Juice

Free to distribute/alter
so long as proper credit to original
author is maintained.

Direct help requests, issue reports, and
suggestions to thejuiceirl@gmail.com

TODO: getItem
TODO: putItem
TODO: equipItem
TODO: placeItem
TODO: setFuelPreference
TODO: refuel
TODO: getmethods
TODO: help
TODO: location keeping

]]

dir=0	--	0=south, 1=west, 2=north, 3=east

function getPos()
	local x,y,z=gps.locate()
	assert(x~=nil,"I'm lost!")
	return x,y,z,dir
end

function setDir(I)
	dir=I%4
end

function addDir(I)
	setDir(dir+I)
end

local bx,by,bz=getPos()

while turtle.forward()~=true do
	turtle.turnRight()
end

local ax,ay,az=getPos()

turtle.back()

if ax>bx then
	dir=3
elseif ax<bx then
	dir=1
elseif az>bz then
	dir=0
elseif az<bz then
	dir=2
else
	error("IDK, this isn't supposed to crash here.")
end

local function forward()
	res,err=turtle.forward()
	if res then
		sleep(.51)
	end
	return res,err
end

local function back()
	res,err=turtle.back()
	if res then
		sleep(.51)
	end
	return res,err
end

local function up()
	res,err=turtle.up()
	if res then
		sleep(.51)
	end
	return res,err
end

local function down()
	res,err=turtle.down()
	if res then
		sleep(.51)
	end
	return res,err
end

local function turnRight()
	res,err=turtle.turnRight()
	if res then
		jTurtle.addDir(1)
		sleep(.51)
	end
	return res,err
end

local function turnLeft()
	res,err=turtle.turnLeft()
	if res then
		jTurtle.addDir(-1)
		sleep(.51)
	end
	return res,err
end


local function doNothing()
	return true
end





function turn(d,lengt)
	local n
	if lengt==nil then
		n=1
	else
		n=lengt
	end
	local func
	if d=="r" then
		func=turnRight
	elseif d=="l" then
		func=turnLeft
	else
		error(d.." is not a valid direction, try: 'r' 'l'")
	end
	for x=1,n do
		func()
	end
	return true
end

function dig(d)
	if d=="f" or d==nil then
		return turtle.dig()
	elseif d=="u" then
		return turtle.digUp()
	elseif d=="d" then
		return turtle.digDown()
	else
		error(d.." is not a valid direction, try: 'f' 'u' 'd'")
	end
end

function place(d,itemName)
	local dum,rea=selectItem(itemName)
	if rea=="missing" then
		return false,"missing"
	end
	
	if d=="f" or d==nil then
		return turtle.place()
	elseif d=="u" then
		return turtle.placeUp()
	elseif d=="d" then
		return turtle.placeDown()
	else
		error(d.." is not a valid direction, try: 'f' 'u' 'd'")
	end
end

function move(d,lengt)
	local leng
	if lengt==nil then
		leng=1
	else
		leng=lengt
	end
	if jTurtle.fuel()<leng then
		return false,leng,"fuel"
	end
	
	local func
	if d=="f" or d==nil then
		func=forward
	elseif d=="b" then
		func=back
	elseif d=="u" then
		func=up
	elseif d=="d" then
		func=down
	else
		error(d.." is not a valid direction, try: 'f' 'b' 'u' 'd'")
	end
	for n=1,leng do
		local tries=0
		while not func() and tries<10 do
			tries=tries+1
			sleep(.5)
		end
		if tries==10 then
			return false,leng-n+1,"obst"
		end
	end
	return true,0
end

function tunnel(d,lengt,di1,di2)
	local leng
	if lengt==nil then
		leng=1
	else
		leng=lengt
	end
	if jTurtle.fuel()<leng then
		return false,leng,"fuel"
	end
	
	local func=doNothing
	local digfunc=doNothing
	local digfunc1=doNothing
	local digfunc2=doNothing
	
	if d=="f" or d==nil then
		func=forward
		digfunc=turtle.dig
		digfunc1=turtle.digDown
		digfunc2=turtle.digUp
	elseif d=="b" then
		func=back
		digfunc1=turtle.digDown
		digfunc2=turtle.digUp
	elseif d=="u" then
		func=up
		digfunc=turtle.digUp
		digfunc1=turtle.dig
	elseif d=="d" then
		func=down
		digfunc=turtle.digDown
		digfunc1=turtle.dig
	else
		error(d.." is not a valid direction, try: 'f' 'b' 'u' 'd'")
	end
	for n=1,leng do
		local tries=0
		digfunc()
		while not func() and tries<10 do
			tries=tries+1
			digfunc()
		end
		if di1 then
			digfunc1()
		end
		if di2 then
			digfunc2()
		end
		if tries==10 then
			return false,leng-n+1,"obst"
		end
	end
	return true,0
end





function turnTo(d)
	local sd=dir
	if (d-sd)%4==2 then
		turn('r',2)
	elseif (d-sd)%4==1 then
		turn('r',1)
	elseif (d-sd)%4==3 then
		turn('l',1)
	elseif (d-sd)%4==0 then

	else
		error("input out of range, must be >=0 and <=3 and an integer")
	end	
end

function moveTo(x,y,z)
	local sx,sy,sz,sd=getPos()
	if sy>y then
		move('d',sy-y)
	elseif sy<y then
		move('u',y-sy)
	end
	if sx>x then
		turnTo(1)
		move('f',sx-x)
	elseif sx<x then
		turnTo(3)
		move('f',x-sx)
	end
	if sz>z then
		turnTo(2)
		move('f',sz-z)
	elseif sz<z then
		turnTo(0)
		move('f',z-sz)
	end
end






function getItemDetail(slot)
	local d=turtle.getItemDetail(slot)
	if d~=nil then
		return d
	else
		return {count=0,name="minecraft:air",damage=0}
	end
end

function selectItem(name)
	if type(name)=="string" then
		if getItemDetail(turtle.getSelectedSlot()).name~=name then
			local n=1
			while getItemDetail(n).name~=name and n<16 do
				n=n+1
			end
			if getItemDetail(n).name==name then
				turtle.select(n)
				return true
			else
				return false,"missing"
			end
		else
			return true
		end
	elseif type(name)=='number' and name>=1 and name<=16 and name==math.floor(name) then
		turtle.select(name)
	else
		return false,"non-str-or-num"
	end
end

function equipItem(side,name)
	local dum,rea=selectItem(name)
	if rea=="missing" then
		return false,"missing"
	end
	
	if side=='r' then
		turtle.equipRight()
	elseif side=='l' then
		turtle.equipLeft()
	else
		error(side.." is not a valid side, try: 'l' 'r'")
	end
end

function unequipItem(side)
	local dum,rea=selectItem("minecraft:air")
	if rea=="missing" then
		return false,"noSpace"
	end
	
	if side=='r' then
		turtle.equipRight()
	elseif side=='l' then
		turtle.equipLeft()
	else
		error(side.." is not a valid side, try: 'l' 'r'")
	end
end

function fuel()
	return turtle.getFuelLevel()
end

--[[
function refuel()
	
end
]]