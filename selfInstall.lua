local function install(pkg,verb,dep,db,ldb)
	if not db[pkg] then
		return false, "'"..pkg.."' package does not exist."
	end
	if verb and verb>1 then print("Preparing to install '"..pkg.."'") end
	
	for k,v in pairs(db[pkg].depends) do
		if not ldb[v] then
			if not install(v,verb,true,db,ldb) then return false, "Dependency '"..v.."' could not be installed." end
		end
	end
	
	if verb and verb>1 then print("Downloading '"..pkg.."'") end
	local path="/tmp/ccr/"..pkg.."_"..db[pkg].version..".pack"
	local response=http.get(db[pkg].package)
	if not response then return false,"Error retrieving '"..pkg.."' package from \""..db[pkg].package..'"' end
	
	local f=fs.open(path,'w')
	repeat
		local rl=response.read(20)
		f.write(rl)
	until rl==nil
	f.close()
	
	remove(pkg,verb and verb-1,true)
	
	if verb and verb>0 then print("installing '"..pkg.."'") end
	pack.packdown(path,"/")
	
	ldb[pkg]=db[pkg]
	ldb[pkg].explicit=not dep
	saveldb(ldb)
	return true
end




if http==nil then
	print("Your server settings do not allow the http library")
	print("CCRepo requires the http library")
	return false
end

print("Creating database file")
local response=http.get("https://github.com/TheJuiceFR/CCRepo/raw/main/database")
if not response then
	print("Cannot retrieve database file")
	return false
end
local dbf=fs.open("/cfg/ccr/db",'w')
repeat
	local rl=response.read(20)
	dbf.write(rl)
until rl==nil
dbf.close()
local db=loadfile("/cfg/ccr/db")()
local ldb={}

install("ccr",3,false,db,ldb)

print("Creating local database")

local f=fs.open("/cfg/ccr/ldb",'w')
f.write("local database=")
f.write(textutils.serialize(ldb))
f.write("\n\nreturn database")
f.close()
