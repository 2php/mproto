local parser = require("sprotoparser")
local core = require("sproto.core")
local print_r = require("print_r")
local json = require("cjson")

local sp = parser.parse [[
.equippack {
	.equip {
	id 0 : integer 
	name 1 : string 
	res 2 : string 
	type 3 : integer 
	subType 4 : integer 
    starLevel 5 : integer 
    talent 6 : integer 
    gender 7 : integer 
    heroList 8 : string 
    atk 9 : integer 
    def 10 : integer 
    hp 11 : integer 
    mp 12 : integer 
    atkGrow 13 : integer 
    defGrow 14 : integer 
    hpGrow 15 : integer 
    mpGrow 16 : integer 
    atkRatio 17 : integer 
    defRatio 18 : integer 
    hpRatio 19 : integer 
    mpRatio 20 : integer 
    atkRatioGrow 21 : integer 
    defRatioGrow 22 : integer 
    hpRatioGrow 23 :integer 
    mpRatioGrow 24 : integer 
    desc 25 : string
}
    pack 0 : *equip
}
]]

local file = io.open("soul.json", "r")
assert(file)
local data = file:read("*a")
file:close()

local input = json.decode(data)
-- print(input[1].id)

sp = core.newproto(sp)

local st = core.querytype(sp, "equippack")

-- local obj = {
-- 	pack = {
--   {
--     id = 1001,
--     name = "盘古斧",
--     res = "zb_1001",
--     type = 1,
--     subType = 1,
--     starLevel = 0,
--     talent = 15,
--     gender = 3,
--     heroList = "[1002,1004]",
--     atk = 300,
--     def = 0,
--     hp = 0,
--     mp = 0,
--     atkGrow = 72,
--     defGrow = 0,
--     hpGrow = 0,
--     mpGrow = 0,
--     atkRatio = 0,
--     defRatio = 0,
--     hpRatio = 0,
--     mpRatio = 0,
--     atkRatioGrow = 0,
--     defRatioGrow = 0,
--     hpRatioGrow = 0,
--     mpRatioGrow = 0,
--     desc = "上古神器"
--   },

--   {
--     id = 1001,
--     name = "盘古斧",
--     res = "zb_1001",
--     type = 1,
--     subType = 1,
--     starLevel = 1,
--     talent = 15,
--     gender = 3,
--     heroList = "[1002,1004]",
--     atk = 380,
--     def = 0,
--     hp = 0,
--     mp = 0,
--     atkGrow = 72,
--     defGrow = 0,
--     hpGrow = 0,
--     mpGrow = 0,
--     atkRatio = 0,
--     defRatio = 0,
--     hpRatio = 0,
--     mpRatio = 0,
--     atkRatioGrow = 0,
--     defRatioGrow = 0,
--     hpRatioGrow = 0,
--     mpRatioGrow = 0,
--     desc = "上古神器"
--   },
-- }}

local obj = { pack = input }

local code = core.encode(st, obj)
parser.dump(code)
print("\n")
local pack = core.pack(code)
parser.dump(pack)

local file = io.open("equip_b","w")
assert(file)
file:write(code)
file:close()

print("\n")
local unpa = core.unpack(pack)
parser.dump(unpa)
print("\n")
obj = core.decode(st, unpa)
print(type(obj))
print(obj.pack[1].name)
print_r(obj)