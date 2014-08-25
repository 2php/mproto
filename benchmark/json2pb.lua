local parser = require("sprotoparser")
local core = require("sproto.core")
local json = require("cjson")
local lfs = require("lfs")

local function trans(filename, filepath)

   local file = io.open(filepath .. ".json", "r")
   assert(file)
   local data = file:read("*a")
   
   local input = json.decode(data)

   local proto = nil
   if type(input[1]) == "number" then
      proto =   ".".. filename .. "_pack { pack 0 : *integer }"
   elseif type(input[1]) == "table" then
      local protocol = {}
      local head =  ".".. filename .. "_pack {\n" .. "." .. filename .. "{\n"
      table.insert(protocol, head)
      
      local i = 0
      for k, v in pairs(input[1]) do
	 if type(v) == "number" then
	    protocol[#protocol + 1] = k .. " " .. i .. " " .. ": " .. "integer\n"
	 elseif type(v) == "string" then
	    protocol[#protocol + 1] = k .. " " .. i .. " " .. ": " .. "string\n"
	 end
	 i = i + 1
      end
      
      local foot = "}\npack 0 : *" .. filename .. "\n}"
      table.insert(protocol, foot)
      proto = table.concat(protocol)
   end
   
   file = io.open(filepath .. ".proto", "w")
   assert(file)
   file:write(proto)
   
   local sp = parser.parse(proto)
   sp = core.newproto(sp)
   local st = core.querytype(sp, filename .. "_pack")
   local obj = { pack = input }
   
   local code = core.encode(st, obj)
   local pack = core.pack(code)
   
   file = io.open(filepath .. ".bin", "w")
   assert(file)
   file:write(pack)
   file:close()
end

print("enter the files path:")

local filepath = io.read()
if filepath == "" then
   filepath = "."
end

local filetable = {}

for name in lfs.dir(filepath) do
   if name ~= "." and name ~= ".." then
      if string.find(name, "%.json") ~= nil then
	 local idx = name:match(".+()%.%w+$")
	 if idx then
	    name = name:sub(1, idx-1)
	 end
	 local path = filepath .. "/" .. name
	 filetable[name] = path
      end
   end
end

for name, path in pairs(filetable) do
   trans(name, path)
end
