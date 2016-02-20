local wifi = require "hs.wifi"
local notify = require "hs.notify"
local timer = require "hs.timer"
local notificationUtils = require "../utils/notification"
local application = require "hs.application"

-- WORK-RELATED AUTOMATION --

-- Open Zenefits Dashboard once connected to WiFi network at work.
local workWifi = "ActiveLAMP Airport"
local employeeDashboardUrl = "https://secure.zenefits.com/dashboard/#/"
local defaultBrowser = "Google Chrome"

local function onWorkNetwork()
  -- Allowance for internet connectivity delays.
  timer.doAfter(3, function ()
    -- @todo: Explore possibilities of using `hs.webview`
    hs.execute("open " .. employeeDashboardUrl)
    notify.new(function () 
      local browser = application.launchOrFocus(defaultBrowser)
    end, {title="Make sure you clock in!"}):send()
  end)
end


-- Check on reload.
local currentWifi = wifi.currentNetwork()
if currentWifi and currentWifi == workWifi then onWorkNetwork() end

wifi.watcher.new(function ()
  local currentWifi = wifi.currentNetwork()
  -- short-circuit if simply disconnecting.
  if not currentWifi then return end

  notificationUtils.withdrawAfter(3, notify.new({
    title="Connected to WiFi",
    informativeText="Now connected to " .. currentWifi
  }):send())
  if currentWifi == workWifi then
    onWorkNetwork()
  end
end):start()

-- END WORK-RELATED AUTOMATION --

