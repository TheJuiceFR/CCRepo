
lfs=require("lfs")

local function buildTree(infil,pack,depth,trail)
	if not depth then depth=0 end
	for n in lfs.dir(infil) do
		if n~="." and n~=".." then
			local f=infil.."/"..n
			if lfs.attributes(f).mode=="directory" then
				if trail then
					pack:write(trail.."/"..n)
					pack:write("\n")
					buildTree(f,pack,depth+1,trail.."/"..n)
				else
					pack:write(n)
					pack:write("\n")
					buildTree(f,pack,depth+1,n)
				end
			end
		end
	end
end

local function buildDump(infil,pack,path)
	local list
	if path then
		list=infil.."/"..path
	else
		list=infil
	end
	for n in lfs.dir(list) do
		if n~="." and n~=".." then
			local f				--file path relative to infile
			if path then 
				f=path.."/"..n
			else 
				f=n 
			end
			local fp=infil.."/"..f		--absolute file path
			local a=lfs.attributes(fp)
			if a.mode=="directory" then
				buildDump(infil,pack,f)
			else
				pack:write(f)
				pack:write(">")
				pack:write(tostring(a.size))
				pack:write(">")
				local ff=io.open(fp,'r')
				for ch=1,a.size do
					pack:write(ff:read(1))
				end
				ff:close()
			end
		end
	end
end

function packup(infil,outfil)
	assert(lfs.attributes(infil).mode=="directory","Input is not a directory")
	local pack=io.open(outfil,'w')
	assert(pack,"Output path invalid")
	buildTree(infil,pack)
	pack:write("\n")
	buildDump(infil,pack)
	pack:close()
end




for name in lfs.dir(lfs.currentdir()) do
	if string.sub(name,1,1)~="." and lfs.attributes(lfs.currentdir().."/"..name).mode=="directory" then
		packup(lfs.currentdir().."/"..name.."/source",lfs.currentdir().."/"..name.."/pkg.pack")
	end
end



