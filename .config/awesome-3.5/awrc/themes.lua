-- THEMES

beautiful.init(awful.util.getdir("config") .. "/themes/default.lua" )

-- Wallpaper
if beautiful.wallpaper then
    for s = 1, screen.count() do
        gears.wallpaper.maximized(beautiful.wallpaper, s, true)
    end
end

