local M = {}

M.primary   = "rgba(4b4b4bff)" -- active window border
M.surface   = "rgba(1a1a1aff)" -- inactive border
M.secondary = "rgba(3e3e3eff)" -- grouped active border
M.error     = "rgba(ff5555ff)" -- locked/error border
M.tertiary  = "rgba(2c2c2cff)" -- extra neutral tone
M.surface_lowest = "rgba(292929ff)" -- dark background-ish tone

M.general = {
	col = {
		active_border = M.primary,
		inactive_border = M.surface,
	},
}

M.group = {
	col = {
		border_active = M.secondary,
		border_inactive = M.surface,
		border_locked_active = M.error,
		border_locked_inactive = M.surface,
	},
	groupbar = {
		col = {
			active = M.secondary,
			inactive = M.surface,
			locked_active = M.error,
			locked_inactive = M.surface,
		},
	},
}

M.config = {
	general = M.general,
	group = M.group,
}
        
return M
