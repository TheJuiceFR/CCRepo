for _,f in pairs(fs.list("/lib")) do
    os.unloadAPI("/lib/"..f)
    os.loadAPI("/lib/"..f)
end