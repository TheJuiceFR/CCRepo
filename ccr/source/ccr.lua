local tArgs={...}

local option=tArgs[1]

local function usageText()
print([[Usage: ccr <option> [arguments]
	ccr install <package1> [package2]...
		installs listed package(s)
	ccr remove <package1> [package2]...
		removes listed package(s)
	ccr update
		updates all packages
	ccr info <package>
		gives info about package
	ccr list
		lists installed packages
	ccr listall
		lists all available packages
]])
end


if option=="install" then
	
elseif option=="remove" then
	
elseif option=="update" then
	
elseif option=="info" then
	
elseif option=="list" then
	
elseif option=="listall" then
	
else
	usageText()
end