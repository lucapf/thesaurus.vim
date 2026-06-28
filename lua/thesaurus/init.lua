local M = {}

M.config = {
	key = "<leader>ct",
	script = vim.api.nvim_get_runtime_file("scripts/thesaurus.sh", false)[1],
}

local out_buf = nil
local function show_output(lines)
	if not out_buf or vim.api.nvim_buf_is_valid(out_buf) then
		out_buf = vim.api.nvim_create_buf(false, true)
	end
	vim.bo[out_buf].modifiable = true
	vim.api.nvim_buf_set_lines(out_buf, 0, -1, false, lines)
	vim.bo[out_buf].modifiable = false
	local width = 0
	for _, l in ipairs(lines) do
		width = math.max(width, #l)
	end
	local main_win = vim.api.nvim_get_current_win() -- grab it first
	local main_width = vim.api.nvim_win_get_width(main_win)

	-- e.g. make the popup 80% of the main window's width
	width = math.min(width, math.floor(main_width * 0.8))
	local num_lines = math.min(#lines, 10)
	local win = vim.api.nvim_open_win(out_buf, true, {
		relative = "cursor",
		row = 1, -- 1 line below the cursor
		col = 0, -- aligned to cursor column
		width = width,
		height = num_lines,
		style = "minimal", -- no numbers/statusline/etc.
		border = "rounded",
	})
	vim.wo[win].wrap = true
	vim.wo[win].linebreak = true
	vim.wo[win].showbreak = "↪  "
	vim.keymap.set("n", "q", function()
		if out_buf ~= nil then
			vim.api.nvim_win_close(win, true)
			out_buf = nil
		end
	end, { buffer = out_buf, nowait = true, silent = true })
end

function M.run()
	local file = vim.api.nvim_buf_get_name(0) -- full path of current buffer
	if file == "" then
		vim.notify("Render: this buffer isn't a saved file", vim.log.levels.WARN)
		return
	end
	local selected_word = vim.fn.expand("<cword>")
	vim.cmd("write") -- save first, so the script sees your latest edits

	local result = vim.system({ M.config.script, selected_word }, { text = true }):wait()
	local output = (result.stdout or "") .. (result.stderr or "")
  if result.code ~= 0 then
		vim.notify(output, vim.log.levels.ERROR)
    return 
  end  

	show_output(vim.split(output, "\n", { trimempty = true }))
end

function M.setup(opts)
	M.config = vim.tbl_extend("force", M.config, opts or {})

	vim.keymap.set("n", M.config.key, M.run, { desc = "<leader> ct - Thesaurus" })
end

return M
