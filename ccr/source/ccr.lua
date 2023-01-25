local tArgs={...}

local option=tArgs[1]

local function usageText()
print([[Usage: ccr <option> [arguments]
	ccr install <package1> [package2]...
		installs listed package(s)
	ccr remove <package1> [package2]...
		removes listed package(s)
	ccr purge <package1> [package2]..
		removes listed package(s) and it's config files
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
	if tArgs[2]==nil then
		print("No package name given")
		return
	end
	ccr.sync(1)
	
	tArgs[1]==nil
	for k,v in pairs(tArgs) do
		ccr.install(v,1)
	end
	ccr.clearCache(0)
elseif option=="remove" then
	if tArgs[2]==nil then
		print("No package name given")
		return
	end
	
	tArgs[1]==nil
	for k,v in pairs(tArgs) do
		ccr.remove(v,1)
	end
elseif option=="purge" then
	if tArgs[2]==nil then
		print("No package name given")
		return
	end
	
	tArgs[1]==nil
	for k,v in pairs(tArgs) do
		ccr.purge(v,1)
	end
elseif option=="update" then
	
elseif option=="info" then
	if tArgs[2]==nil then
		print("No package name given")
		return
	end
	ccr.sync(0)
	
	local db=ccr.loaddb()
	local ldb=ccr.loadldb()
	
	tArgs[1]==nil
	for k,v in pairs(tArgs) do
		if db[v] then
			print(v..":")
			print("version: "..db[v].version)
			print("description: "..db[v].description)
			if db[v].provides[1] then
				write("provides: ")
				for k2,v2 in pairs(db[v].provides) do
					write(v2..", ")
				end
			end
			if db[v].depends[1] then
				write("requires: ")
				for k2,v2 in pairs(db[v].depends) do
					write(v2..", ")
				end
			end
			if db[v].optDepends[1] then
				print("Optional packages: ")
				for k2,v2 in pairs(db[v].optDepends) do
					print(v2[1]..": "..v2[2])
				end
			end
		else
			print("'"..v"' is not in main database")
		end
		if ldb[v] and (db[v]==nil or ldb[v].version~=db[v].version) then
			print("local version: "..ldb[v].version)
		else
			print("'"..v"' is not installed locally")
		end
	end
elseif option=="list" then
	local ldb=ccr.loadldb()
	
	for k,v in pairs(ldb) do
		print(k..":",v.version)
	end
	
elseif option=="listall" then
	ccr.sync(0)
	local db=ccr.loaddb()
	for k,v in pairs(db) do
		print(k..":",v.version)
	end
else
	usageText()
end