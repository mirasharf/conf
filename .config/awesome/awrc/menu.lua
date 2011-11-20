-- MENU

devmenu = {
    { "gvim", "gvim" }
}

networkmenu = {
    { "firefox",        "firefox" },
    { "chromium",       "chromium --disk-cache-size=52428800" },
    { "thunderbird",    "thunderbird" },
    { "pidgin",         "pidgin" },
    { "skype",          "skype" },
    { "xchat",          "xchat" }
}

awesomemenu = {
    { "edit config",    editor_cmd .. " " .. awful.util.getdir("config") .. "/rc.lua" },
    { "restart",        awesome.restart },
    { "lock",           "xlock -mode blank" },
    { "quit",           awesome.quit },
    { "halt",           "shutdown-logout halt" },
    { "reboot",         "shutdown-logout reboot" },
    { "suspend",        "xlock -mode blank -startCmd 'sudo pm-suspend'"}
}

mainmenu = awful.menu({
    items = {
        { "terminal",   terminal },
        { "dev",        devmenu },
        { "network",    networkmenu },
        { "awesome",    awesomemenu }
    }
})

