-- BINDINGS

-- {{{ Mouse bindings
root.buttons(awful.util.table.join(
    awful.button({ }, 3, function () mainmenu:toggle() end),
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev))
)

clientbuttons = awful.util.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))
-- }}}

-- {{{ Key bindings

local delayed_window_focus = {}
delayed_window_focus.timer = timer { timeout = 1 }
delayed_window_focus.focus = nil
delayed_window_focus.count = 0
delayed_window_focus.timer:connect_signal("timeout",
    function()
        if delayed_window_focus.focus then
            client.focus = delayed_window_focus.focus
            client.focus:raise()
        end

        delayed_window_focus.count = delayed_window_focus.count + 1
        if delayed_window_focus.count > 2 then
            delayed_window_focus.count = 0
            delayed_window_focus.timer:stop()
        end
    end)

-- Global
local globalkeys = awful.util.table.join(
    -- Tags
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev       ),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext       ),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore),

    awful.key({ modkey,           }, "j",
        function ()
            awful.client.focus.byidx( 1)
            if client.focus then client.focus:raise() end
        end),
    awful.key({ modkey,           }, "k",
        function ()
            awful.client.focus.byidx(-1)
            if client.focus then client.focus:raise() end
        end),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end),

    -- Awesome control
    awful.key({ modkey, "Control" }, "r",      awesome.restart),
    awful.key({ modkey, "Shift"   }, "q",      awesome.quit),

    awful.key({ modkey,           }, "l",      function () awful.tag.incmwfact( 0.05)    end),
    awful.key({ modkey,           }, "h",      function () awful.tag.incmwfact(-0.05)    end),
    awful.key({ modkey, "Shift"   }, "h",      function () awful.tag.incnmaster( 1)      end),
    awful.key({ modkey, "Shift"   }, "l",      function () awful.tag.incnmaster(-1)      end),
    awful.key({ modkey, "Control" }, "h",      function () awful.tag.incncol( 1)         end),
    awful.key({ modkey, "Control" }, "l",      function () awful.tag.incncol(-1)         end),
    awful.key({ modkey,           }, "space",  function () awful.layout.inc(layouts,  1) end),
    awful.key({ modkey, "Shift"   }, "space",  function () awful.layout.inc(layouts, -1) end),

    awful.key({ modkey, "Control" }, "n", awful.client.restore),

    awful.key({ modkey, "Shift" }, "d", function()
        setup_runtime_error_handler()
        naughty.notify({ title = "Debugging", text = "Set up runtime error handler!", timeout = 3 })
        end),

    -- Prompt
    awful.key({ modkey },            "r",      function () mypromptbox[mouse.screen]:run() end),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run({ prompt = "Run Lua code: " },
                      mypromptbox[mouse.screen].widget,
                      awful.util.eval, nil,
                      awful.util.getdir("cache") .. "/history_eval")
              end),

    -- Menubar (Awesome's menubar, new in 3.5)
    awful.key({ modkey, "Control" }, "p", function() menubar.show() end),

    -- Mouse control
    awful.key({ modkey, "Control" }, "Left",
        function ()
            mouse.coords({ -- Move mouse cursor far left
            x=mouse.coords().x - screen[mouse.screen].workarea.width,
            y=0 }) -- set y=mouse.coords().y to keep y
        end),
    awful.key({ modkey, "Control" }, "Right",
        function ()
            mouse.coords({ -- Move mouse cursor far right
            x=mouse.coords().x + screen[mouse.screen].workarea.width,
            y=0 }) -- set y=mouse.coords().y to keep y
        end),

    -- rough keyboard mouse control
    awful.key({ modkey, "Control" }, "w",
        function () mouse.coords({ x = mouse.coords().x, y = mouse.coords().y - 8 }) end),
    awful.key({ modkey, "Control" }, "s",
        function () mouse.coords({ x = mouse.coords().x, y = mouse.coords().y + 8 }) end),
    awful.key({ modkey, "Control" }, "a",
        function () mouse.coords({ x = mouse.coords().x - 8, y = mouse.coords().y }) end),
    awful.key({ modkey, "Control" }, "d",
        function () mouse.coords({ x = mouse.coords().x + 8, y = mouse.coords().y }) end),
    -- Need to specify each possibly combination, as it is otherwise impossible to issue e.g., Shift+MB1
    awful.key({ modkey,           }, "F6", function () awful.util.spawn("xdotool click --clearmodifiers 1") end),
    awful.key({ modkey,           }, "F7", function () awful.util.spawn("xdotool click --clearmodifiers 2") end),
    awful.key({ modkey,           }, "F8", function () awful.util.spawn("xdotool click --clearmodifiers 3") end),
    awful.key({ modkey, "Shift"   }, "F6", function () awful.util.spawn("xdotool click --clearmodifiers 1") end),
    awful.key({ modkey, "Shift"   }, "F7", function () awful.util.spawn("xdotool click --clearmodifiers 2") end),
    awful.key({ modkey, "Shift"   }, "F8", function () awful.util.spawn("xdotool click --clearmodifiers 3") end),
    awful.key({ modkey, "Control" }, "F6", function () awful.util.spawn("xdotool click --clearmodifiers 1") end),
    awful.key({ modkey, "Control" }, "F7", function () awful.util.spawn("xdotool click --clearmodifiers 2") end),
    awful.key({ modkey, "Control" }, "F8", function () awful.util.spawn("xdotool click --clearmodifiers 3") end),
    awful.key({ modkey, "Control" },  ";", function () delayed_window_focus.focus = client.focus end),
    awful.key({ modkey,           },  ";",
        function ()
            awful.util.spawn_with_shell("sleep 0.5 && xdotool click --clearmodifiers 1")
            delayed_window_focus.timer:start()
        end),

    -- Programs
    -- launchers
    awful.key({ modkey,           }, "w",      function () mainmenu:show() end),
    awful.key({ modkey,           }, "p",      function () awful.util.spawn("bash -c 'exe=`dmenu-apps echo` && eval \"exec $exe\"'") end),
    awful.key({ modkey, "Shift"   }, "p",      function () awful.util.spawn("gmrun") end),
    awful.key({ modkey,           }, "Return", function () awful.util.spawn(terminal) end),
    awful.key({ modkey, "Shift"   }, "Return", function () awful.util.spawn(terminal_alt) end),
    -- miscellaneous
    awful.key({ modkey, "Control" }, "x",      function () awful.util.spawn("xlock-screenoff") end),
    awful.key({ modkey, "Shift"   }, "x",      function () awful.util.spawn("xlock -mode blank") end),
    -- web
    awful.key({ modkey,           }, "f",      function () awful.util.spawn(browser) end),
    awful.key({ modkey, "Shift"   }, "f",      function () awful.util.spawn(browser_private) end),
    awful.key({ modkey,           }, "e",      function () awful.util.spawn(mail_client) end),
    -- file managers
    awful.key({ modkey, "Shift"   }, "t",      function () awful.util.spawn("thunar") end)
)

-- Clients
clientkeys = awful.util.table.join(
    awful.key({ modkey, "Control" }, "f",      function (c) c.fullscreen = not c.fullscreen  end),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill() end),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle ),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end),
    awful.key({ modkey,           }, "o",      awful.client.movetoscreen ),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop end),
    awful.key({ modkey,           }, "n",      function (c) c.minimized = true end),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c.maximized_vertical   = not c.maximized_vertical
        end)
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it works on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    -- View tag only.
    globalkeys = awful.util.table.join(globalkeys,
    awful.key({ modkey }, "#" .. i + 9,
    function ()
        local screen = mouse.screen
        local tag = awful.tag.gettags(screen)[i]
        if tag then
            awful.tag.viewonly(tag)
        end
    end),
    -- Toggle tag.
    awful.key({ modkey, "Control" }, "#" .. i + 9,
    function ()
        local screen = mouse.screen
        local tag = awful.tag.gettags(screen)[i]
        if tag then
            awful.tag.viewtoggle(tag)
        end
    end),
    -- Move client to tag.
    awful.key({ modkey, "Shift" }, "#" .. i + 9,
    function ()
        if client.focus then
            local tag = awful.tag.gettags(client.focus.screen)[i]
            if tag then
                awful.client.movetotag(tag)
            end
        end
    end),
    -- Toggle tag.
    awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
    function ()
        if client.focus then
            local tag = awful.tag.gettags(client.focus.screen)[i]
            if tag then
                awful.client.toggletag(tag)
            end
        end
    end))
end

-- Set keys
root.keys(globalkeys)
--- }}}

