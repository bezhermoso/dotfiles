local window = require "hs.window"
local screen = require "hs.screen"
local hotkey = require "hs.hotkey"
local fnutils = require "hs.fnutils"
local pathwatcher = require "hs.pathwatcher"
local notify = require "hs.notify"
local wifi = require "hs.wifi"
local alert = require "hs.alert"
local timer = require "hs.timer"
local application = require "hs.application"
local urlevent = require "hs.urlevent"

-- DISPLAY FOCUS SWITCHING --

--Bring focus to next display/screen
hotkey.bind({"alt", "ctrl"}, "L", function ()
  focusScreen(window.focusedWindow():screen():next())
end)

function isInScreen(screen, win)
  return win:screen() == screen
end

function focusScreen(screen)
  --Get windows within screen, ordered from front to back.
  --If no windows exist, bring focus to desktop. Otherwise, set focus on
  --front-most application window.
  windows = fnutils.filter(window.orderedWindows(), fnutils.partial(isInScreen, screen))
  local windowToFocus = #windows > 0 and windows[1] or window.desktop()
  windowToFocus:focus()
end

--Bring focus to previous display/screen
hotkey.bind({"alt", "ctrl"}, "H", function() 
  focusScreen(window.focusedWindow():screen():previous())
end)

-- END DISPLAY FOCUS SWITCHING --

-- WORK-RELATED AUTOMATION --

-- Open Zenefits Dashboard once connected to WiFi network at work.
local workWifi = "ActiveLAMP Airport"
local employeeDashboardUrl = "https://secure.zenefits.com/dashboard/#/"
local defaultBrowser = "Google Chrome"

wifi.watcher.new(function ()
  local currentWifi = wifi.currentNetwork()
  -- short-circuit if simply disconnecting.
  if not currentWifi then return end

  local note = notify.new({title="Connected to WiFi", informativeText="Now connected to " .. currentWifi}):send()
  timer.doAfter(3, function ()
    note:withdraw()
  end)
  if currentWifi == workWifi then
    -- Allowance for internet connectivity delays.
    timer.doAfter(3, function ()
      -- @todo: Explore possibilities of using `hs.webview`
      hs.execute("open " .. employeeDashboardUrl)
      notify.new(function () 
        local browser = application.launchOrFocus(defaultBrowser)
      end, {title="Make sure you clock in!"}):send()
    end)
  end
end):start()

-- END WORK-RELATED AUTOMATION --


-- RAMEN TIMER --

-- Ramen timer to be triggered with hammerspoon://ramentime,
-- which is bound to an Alfred workflow
function startRamenTimer()
  timer.doAfter(3 * 60, function ()
    notify.new({title="Ramen time!", informativeText="Your ramen is ready!"}):send()
  end)
  alert(" Ramen timer started! ")
end

urlevent.bind("ramentime", startRamenTimer)
hotkey.bind({"ctrl", "alt", "cmd"}, "R", startRamenTimer)

-- END RAMEN TIMER --

--Straight out of the docs.
--http://www.hammerspoon.org/go/#fancyreload
function reloadConfig(files)
  doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end

pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()
alert(" Hammerspoon configuration reloaded! ")
