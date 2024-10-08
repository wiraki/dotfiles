function Status:name()
	local h = self._tab.current.hovered
	if not h then
		return ui.Line({})
	end

	local linked = ""
	if h.link_to ~= nil then
		linked = " -> " .. tostring(h.link_to)
	end
	return ui.Line(" " .. h.name .. linked)
end

-- Full border
require("full-border"):setup({
	-- Available values: ui.Border.PLAIN, ui.Border.ROUNDED
	type = ui.Border.ROUNDED,
})

-- Relative motions
require("relative-motions"):setup({
	show_numbers = "relative",
	show_motion = true,
})

-- Custome linemode to show both size and mtime
function Linemode:size_and_mtime()
	local year = os.date("%Y")
	local time = math.floor(self._file.cha.modified or 0)

	if time > 0 and os.date("%Y", time) == year then
		time = os.date("%b %d %H:%M", time)
	else
		time = time and os.date("%b %d  %Y", time) or ""
	end

	local size = self._file:size()
	return ui.Line(string.format(" %s %s ", size and ya.readable_size(size) or "", time))
end

-- yatline (https://github.com/imsi32/yatline.yazi)
-- using yatline-catppuccin (https://github.com/imsi32/yatline-catppuccin.yazi)
local catppuccin_theme = require("yatline-catppuccin"):setup("macchiato") -- or "latte" | "frappe" | "macchiato"
require("yatline"):setup({
	-- ===
	section_separator = { open = "", close = "" },
	part_separator = { open = "", close = "" },
	inverse_separator = { open = "", close = "" },

	-- style_a = {
	-- 	fg = "black",
	-- 	bg_mode = {
	-- 		normal = "#a89984",
	-- 		select = "#d79921",
	-- 		un_set = "#d65d0e"
	-- 	}
	-- },
	-- style_b = { bg = "#665c54", fg = "#ebdbb2" },
	-- style_c = { bg = "#3c3836", fg = "#a89984" },
	--
	-- permissions_t_fg = "green",
	-- permissions_r_fg = "yellow",
	-- permissions_w_fg = "red",
	-- permissions_x_fg = "cyan",
	-- permissions_s_fg = "darkgray",

	tab_width = 20,
	tab_use_inverse = false,

	-- selected = { icon = "󰻭", fg = "yellow" },
	-- copied = { icon = "", fg = "green" },
	-- cut = { icon = "", fg = "red" },
	--
	-- total = { icon = "󰮍", fg = "yellow" },
	-- succ = { icon = "", fg = "green" },
	-- fail = { icon = "", fg = "red" },
	-- found = { icon = "󰮕", fg = "blue" },
	-- processed = { icon = "󰐍", fg = "green" },
	--
	-- show_background = true,
	--
	display_header_line = true,
	display_status_line = true,

	header_line = {
		left = {
			section_a = {
				{ type = "line", custom = false, name = "tabs", params = { "left" } },
			},
			section_b = {},
			section_c = {},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "date", params = { "%A, %d %B %Y" } },
			},
			section_b = {
				{ type = "string", custom = false, name = "date", params = { "%X" } },
			},
			section_c = {},
		},
	},

	status_line = {
		left = {
			section_a = {
				{ type = "string", custom = false, name = "tab_mode" },
			},
			section_b = {
				{ type = "string", custom = false, name = "hovered_size" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_name" },
				{ type = "coloreds", custom = false, name = "count" },
			},
		},
		right = {
			section_a = {
				{ type = "string", custom = false, name = "cursor_position" },
			},
			section_b = {
				{ type = "string", custom = false, name = "cursor_percentage" },
			},
			section_c = {
				{ type = "string", custom = false, name = "hovered_file_extension", params = { true } },
				{ type = "coloreds", custom = false, name = "permissions" },
			},
		},
	},
	-- ===
	theme = catppuccin_theme,
})
