package = "luai"
version = "1.0-1"
source = {
   url = "git://github.com/cschen1205/lua-ai.git",
   tag = "v1.0.1",
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
      ["luai.DecisionTree"] = "src/DecisionTree.lua",
      ["luai.Attribute"] = "src/Attribute.lua",
      ["luai.Logger"] = "src/Logger.lua",
      ["luai.MLP"] = "src/MLP.lua",
      ["luai.NaiveBayesClassifier"] = "src/NaiveBayesClassifier.lua",
      ["luai.Record"] = "src/Record.lua",
      ["luai.TreeNode"] = "src/TreeNode.lua",
      ["luai.samples.GameUtil"] = "src/samples/GameUtil.lua",
      ["luai.samples.GameWorld"] = "src/samples/GameWorld.lua",
      ["luai.samples.GameAgent"] = "src/samples/GameAgent.lua",
      ["luai.samples.GameWeapon"] = "src/samples/GameWeapon.lua",
      ["luai.samples.NBCBot"] = "src/samples/NBCBot.lua",
      ["luai.samples.data"] = "src/samples/data.lua",

   }
}
