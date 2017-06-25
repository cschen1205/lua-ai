package = "luai"
version = "1.0-1"
source = {
   url = "git://github.com/cschen1205/lua-ai.git",
   tag = "v1.0.0",
}
description = {
   summary = "Lua AI Library",
   detailed = [[
      This library contains lua implementation for
      artificial intelligence
   ]],
   homepage = "https://github.com/cschen1205/lua-ai",
   license = "MIT/X11"
}
dependencies = {
   "lua >= 5.1, < 5.4"
}
build = {
   type = "builtin",
   modules = {
      -- Note the required Lua syntax when listing submodules as keys
      ["data.stack"] = "src/data/stack.lua",
   }
}
