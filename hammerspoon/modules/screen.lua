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
  local sc = focused:screen()
  if not sc then return end
  focusScreen(window.focusedWindow():screen():next(), true)
end)

--Bring focus to previous display/screen
hotkey.bind({"alt", "shift"}, "`", function()
  local focused = window.focusedWindow()
  if not focused then return end
  local sc = focused:screen()
  if not sc then return end
  focusScreen(window.focusedWindow():screen():previous(), true)
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

