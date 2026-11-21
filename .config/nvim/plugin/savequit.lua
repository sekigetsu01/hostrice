-- Closing the window from outside (Super+q, bookset) saves and quits instead of losing unsaved writing:
-- the close script reads $XDG_RUNTIME_DIR/nvim-focused (the server of the nvim that has focus) and runs
--   nvim --headless --clean --server "$sock" --remote-expr 'v:lua.SaveQuit()'
-- Text with no file name is thrown away. A named file that can't be written (read-only, failed write) is kept in
-- ~/.local/state/nvim/rescued.
local FOCUSED = (vim.env.XDG_RUNTIME_DIR or "/tmp") .. "/nvim-focused"
local RESCUE = vim.fn.stdpath("state") .. "/rescued"

local function writable(b)
    local bt = vim.bo[b].buftype
    return (bt == "" or bt == "acwrite") and vim.api.nvim_buf_get_name(b) ~= ""
end

local function rescue(b)
    local lines = vim.api.nvim_buf_get_lines(b, 0, -1, false)
    if #lines == 1 and lines[1]:match("^%s*$") then return nil end
    vim.fn.mkdir(RESCUE, "p")
    local base = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(b), ":t")
    local file = ("%s/%s-%d-%s"):format(RESCUE, os.date("%Y%m%d-%H%M%S"), b, base)
    if vim.fn.writefile(lines, file) ~= 0 then return nil end
    return file
end

-- write every changed file, then quit without asking (Goyo's quit hook and :confirm stay out of it);
-- returns what it did, for the caller
function _G.SaveQuit()
    vim.g.wiki_goyo = 0
    local saved, rescued = 0, {}
    for _, b in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_loaded(b) and vim.bo[b].modified and vim.bo[b].buftype ~= "terminal" then
            if writable(b) and not vim.bo[b].readonly then
                vim.api.nvim_buf_call(b, function() vim.cmd("silent! keepalt keepjumps update") end)
            end
            if not vim.bo[b].modified then
                saved = saved + 1
            elseif (vim.bo[b].buftype == "" or vim.bo[b].buftype == "acwrite") and vim.api.nvim_buf_get_name(b) ~= "" then
                rescued[#rescued + 1] = rescue(b)
            end
        end
    end
    if #rescued > 0 then
        vim.system({ "notify-send", "--app-name=Neovim", "Unsaved text kept", table.concat(rescued, "\n") }, { detach = true })
    end
    vim.schedule(function() vim.cmd("silent! qall!") end)
    return ("saved %d%s"):format(saved, #rescued > 0 and (", rescued " .. #rescued) or "")
end

vim.api.nvim_create_user_command("SaveQuit", function() _G.SaveQuit() end,
    { desc = "Save every changed file and quit without asking" })

-- the focused nvim's server, for the close key: claimed on focus, released (if still ours) when it goes
local function claim()
    -- (a focus event held back by a Press ENTER prompt can arrive while quitting)
    if vim.v.servername == "" or #vim.api.nvim_list_uis() == 0 or vim.v.exiting ~= vim.NIL then return end
    local tmp = FOCUSED .. "." .. vim.fn.getpid()
    if vim.fn.writefile({ vim.v.servername }, tmp, "b") == 0 then vim.uv.fs_rename(tmp, FOCUSED) end
end
local function release()
    local f = io.open(FOCUSED, "r")
    if not f then return end
    local who = f:read("*a")
    f:close()
    if who == vim.v.servername then os.remove(FOCUSED) end
end
local group = vim.api.nvim_create_augroup("SaveQuit", { clear = true })
vim.api.nvim_create_autocmd({ "UIEnter", "FocusGained" }, { group = group, callback = claim })
vim.api.nvim_create_autocmd({ "FocusLost", "VimLeavePre" }, { group = group, callback = release })
