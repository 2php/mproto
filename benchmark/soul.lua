local parser = require("sprotoparser")
local core = require("sproto.core")
local print_r = require("print_r")
local json = require("cjson")

local sp = parser.parse [[
.soulpack {
	.soul {
	id 0 : integer 
	quality 1 : integer 
	name 2 : string 
	res 3 : string 
	heroID 4 : integer 
	starLevel 5 : integer 
}
    pack 0 : *soul
}
]]

local file = io.open("soul.json", "r")
assert(file)
local data = file:read("*a")
file:close()

local input = json.decode(data)
print(input[1].id)

sp = core.newproto(sp)

local st = core.querytype(sp, "soulpack")

-- local obj = {
-- 	pack = {
-- {
-- 	id = 1001,
-- 	quality = 3,
-- 	name = "元始天尊魂魄",
-- 	res = "hp_1001",
-- 	heroID = 1001,
-- 	starLevel = 0,
-- },
-- {
-- 	id = 1002,
--     quality = 3,
--     name = "盘古神魂魄",
--     res = "hp_1002",
--     heroID = 1002,
--     starLevel = 0
-- },
-- }}

local obj = { pack = input }

local code = core.encode(st, obj)
parser.dump(code)
print("\n")
local pack = core.pack(code)
parser.dump(pack)

local file = io.open("soul_b","w")
assert(file)
file:write(pack)

print("\n")
local unpa = core.unpack(pack)
parser.dump(unpa)
print("\n")
obj = core.decode(st, unpa)
print(type(obj))
print(obj.pack[1].name)
print_r(obj)