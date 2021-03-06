local window = require "hs.window"
local screen = require "hs.screen"
local hotkey = require "hs.hotkey"
local fnutils = require "hs.fnutils"
local geometry = require "hs.geometry"
local mouse = require "hs.mouse"
require "hs.application"

-- DISPLAY FOCUS SWITCHING --

--One hotkey should just suffice for dual-display setups as it will naturally
--cycle through both.
--A second hotkey to reverse the direction of the focus-shift would be handy
--for setups with 3 or more displays.

--Predicate that checks if a window belongs to a screen
local function isInScreen(sc, win)
  return win:screen() == sc
end

mousePositions = {}

local function moveMouseToScreen(sc)
  local pt = geometry.rectMidPoint(sc:fullFrame())
  mouse.setAbsolutePosition(pt)
end

local function focusScreen(sc, moveMouse)
  --Get windows within screen, ordered from front to back.
  --If no windows exist, bring focus to desktop. Otherwise, set focus on
  --front-most application window.
  if not sc then return end

  mousePositions[window.focusedWindow():screen():id()] = mouse.getAbsolutePosition()

  local windows = fnutils.filter(
    window.orderedWindows(),
    fnutils.partial(isInScreen, sc))
  local windowToFocus = #windows > 0 and windows[1] or window.desktop()
  windowToFocus:focus()

  if moveMouse then moveMouseToScreen(sc) end
end

--Bring focus to next display/screen
hotkey.bind({"alt"}, "`", function ()
  local focused = window.focusedWindow()
  if not focused then return end
  local mouseScreen = mouse.getCurrentScreen()
  local focusedScreen = focused:screen()
  local sc = mouseScreen
  if not mouseScreen == focusedScreen then
    sc = focusedScreen
  end
  if not sc then return end
  focusScreen(sc:next(), true)
end)

--Bring focus to previous display/screen
hotkey.bind({"alt", "shift"}, "`", function()
  local focused = window.focusedWindow()
  if not focused then return end
  local mouseScreen = mouse.getCurrentScreen()
  local focusedScreen = focused:screen()
  local sc = mouseScreen
  if not mouseScreen == focusedScreen then
    sc = focusedScreen
  end
  if not sc then return end
  focusScreen(sc:previous(), true)
end)

-- END DISPLAY FOCUS SWITCHING --

-- START PSEUDO FULL-SCREEN --

local padding = 20

local function pseudoFullScreen(win)
  local sc = win:screen()
  local screenFrame = sc:frame()
  local winFrame = win:frame()
  local newRect = geometry.rect(screenFrame.x + padding, screenFrame.y + padding, screenFrame.w - padding * 2, screenFrame.h - padding * 2)
  win:setFrame(newRect)
end

hotkey.bind({"ctrl","alt", "cmd"}, "f", function()
  local win = window.frontmostWindow()
  if win and not win:isFullScreen() then pseudoFullScreen(win) end
end)

-- END PSEUDO FULL-SCREEN --

local function halfScreen(win, position)
  local sc = win:screen()
  local screenFrame = sc:frame()
  local winFrame = win:frame()
  local w = screenFrame.w * 0.5 - (padding * 1.25)
  local h = screenFrame.h - (padding * 2)
  local x = screenFrame.x + padding
  local y = screenFrame.y + padding
  if position == "right" then
    x = x + screenFrame.w * 0.5 - (padding * 0.5)
  end
  local newRect = geometry.rect(x, y, w, h)
  win:setFrame(newRect)
end

-- position: 0-3, clock-wise starting from top-left.
local function quarterScreen(win, position)
  local sc = win:screen()
  local screenFrame = sc:frame()
  local winFrame = win:frame()
  local w = screenFrame.w * 0.5 - (padding * 1.25)
  local h = screenFrame.h * 0.5 - (padding * 1.25)
  local x = screenFrame.x + padding
  local y = screenFrame.y + padding


  if position == 1 or position == 3 then
    x = x + screenFrame.w * 0.5 - (padding * 0.75)
  end

  if position == 2 or position == 3 then
    y = y + screenFrame.h * 0.5 - (padding * 0.75)
  end

  local newRect = geometry.rect(x, y, w, h)
  win:setFrame(newRect)
end

--hotkey.bind({"ctrl","alt", "cmd"}, "left", function()
  --local win = window.frontmostWindow()
  --if win and not win:isFullScreen() then halfScreen(win, "left") end
--end)

--hotkey.bind({"ctrl","alt", "cmd"}, "right", function()
  --local win = window.frontmostWindow()
  --if win and not win:isFullScreen() then halfScreen(win, "right") end
--end)

--hotkey.bind({"ctrl","alt"}, "left", function()
  --local win = window.frontmostWindow()
  --if win and not win:isFullScreen() then quarterScreen(win, 2) end
--end)

--hotkey.bind({"ctrl","alt"}, "right", function()
  --local win = window.frontmostWindow()
  --if win and not win:isFullScreen() then quarterScreen(win, 3) end
--end)

--hotkey.bind({"ctrl","alt", "shift"}, "left", function()
  --local win = window.frontmostWindow()
  --if win and not win:isFullScreen() then quarterScreen(win, 0) end
--end)

--hotkey.bind({"ctrl","alt", "shift"}, "right", function()
  --local win = window.frontmostWindow()
  --if win and not win:isFullScreen() then quarterScreen(win, 1) end
--end)

