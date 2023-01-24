
local function buildTree(infil,pack,depth)
	if not depth then depth=0 end
	for _,n in pairs(fs.list(infil)) do
		local f=infil.."/"..n
		if fs.attributes(f).isDir then
			pack.write(string.rep(">",depth))
			pack.write(n)
			pack.write("\n")
			buildTree(f,pack,depth+1)
		end
	end
end

local function buildDump(infil,pack,path)
	local list
	if path then
		list=fs.list(infil.."/"..path)
	else
		list=fs.list(infil)
	end
	for _,n in pairs(list) do
		local f				--file path relative to infile
		if path then 
			f=path.."/"..n
		else 
			f=n 
		end
		local fp=infil.."/"..f		--absolute file path
		local a=fs.attributes(fp)
		if a.isDir then
			buildDump(infil,pack,f)
		else
			pack.write(f)
			pack.write(">")
			pack.write(tostring(a.size))
			pack.write(">")
			local ff=fs.open(fp,'r')
			for ch=1,a.size do
				pack.write(ff.read(1))
			end
			ff.close()
		end
	end
end

function packup(infil,outfil)
	local pack=fs.open(outfil,'w')
	buildTree(infil,pack)
	--pack.write(">")
	pack.write("\n")
	buildDump(infil,pack)
	pack.close()
end






local function parseTree(pack,outfil,depth)
	
end

function packdown(infil,outfil)
	fs.makeDir(outfil)
	local pack=fs.open(infil,'r')
	
	out=""
	parseTree(pack,outfil,1)
	
end



--[[
dir

>
/test>47>47byteshere/odir/fil.lua>12>






]]