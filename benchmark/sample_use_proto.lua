local parser = require("sprotoparser")
local core = require("sproto.core")
local print_r = require("print_r")

local file = io.open("rp_skill_upgrade.proto", "r")
assert(file)
local proto = file:read("*a")

file = io.open("rp_skill_upgrade.bin", "r")
assert(file)
local bin = file:read("*a")
file:close()

local sp = parser.parse(proto)
sp = core.newproto(sp)
local st = core.querytype(sp, "rp_skill_upgrade_pack")

local unpa = core.unpack(bin)
local result = core.decode(st, unpa)
print(result.pack[1])
print_r(result)
