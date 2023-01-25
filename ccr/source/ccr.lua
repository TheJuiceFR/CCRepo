local tArgs={...}

local option=tArgs[1]

local function usageText()
print([[Usage:



]])
end


if option=="install" then

elseif option=="update" then

elseif option=="remove" then

elseif option=="info" then

elseif option=="list" then

else
	usageText()
end