-- [[ Load Core Configuration ]]
-- This file loads all the core configuration modules

-- Load basic vim options and settings
require("config.options")

-- Load keymaps
require("config.keymaps")

-- Load autocommands
require("config.autocommands")

-- Setup lazy.nvim and load plugins
require("config.lazy")
