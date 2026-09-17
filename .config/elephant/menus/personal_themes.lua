-- Personal theme selector for Walker/Elephant.
Name = "personalthemes"
NamePretty = "Temas personales"
HideFromProviderlist = true

local home = os.getenv("HOME")
local themes_dir = home .. "/.config/themes"
local set_theme = themes_dir .. "/set-theme"

local function file_exists(path)
  local file = io.open(path, "r")
  if file then file:close(); return true end
  return false
end

local function shell_quote(value)
  return "'" .. value:gsub("'", "'\\\"'\\\"'") .. "'"
end

local function expand_home(path)
  if path:sub(1, 2) == "~/" then return home .. path:sub(2) end
  return path
end

local function wallpaper_for(theme_path)
  local config = io.open(theme_path .. "/wallpaper.conf", "r")
  if not config then return nil end
  for line in config:lines() do
    local wallpaper = line:match('^%s*path%s*=%s*"(.-)"%s*$')
    if wallpaper then
      wallpaper = expand_home(wallpaper)
      if file_exists(wallpaper) then config:close(); return wallpaper end
    end
  end
  config:close()
  return nil
end

function GetEntries()
  local entries = {}
  local handle = io.popen("find -L " .. shell_quote(themes_dir) .. " -mindepth 1 -maxdepth 1 -type d -printf '%f\\n' 2>/dev/null | sort")
  if not handle then return entries end
  for name in handle:lines() do
    if name ~= "current" and name:match("^[%w][%w%._%-]*$") then
      local theme_path = themes_dir .. "/" .. name
      if file_exists(theme_path .. "/colors.toml") then
        local wallpaper = wallpaper_for(theme_path)
        local entry = {
          Text = name:gsub("[-_]", " "),
          Subtext = wallpaper and "Wallpaper predeterminado" or "Sin wallpaper predeterminado",
          Actions = { activate = shell_quote(set_theme) .. " " .. shell_quote(name) },
        }
        if wallpaper then entry.Preview = wallpaper; entry.PreviewType = "file" end
        table.insert(entries, entry)
      end
    end
  end
  handle:close()
  return entries
end
