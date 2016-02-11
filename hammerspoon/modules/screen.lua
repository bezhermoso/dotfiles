local window = require "hs.window"
local screen = require "hs.screen"
local hotkey = require "hs.hotkey"
local fnutils = require "hs.fnutils"
local geometry = require "hs.geometry"
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

local function focusScreen(sc)
  --Get windows within screen, ordered from front to back.
  --If no windows exist, bring focus to desktop. Otherwise, set focus on
  --front-most application window.
  if not sc then return end

  local windows = fnutils.filter(
    window.orderedWindows(),
    fnutils.partial(isInScreen, sc))
  local windowToFocus = #windows > 0 and windows[1] or window.desktop()
  windowToFocus:focus()
end

--Bring focus to next display/screen
hotkey.bind({"alt"}, "`", function ()
  focusScreen(window.focusedWindow():screen():next())
end)

--Bring focus to previous display/screen
hotkey.bind({"alt", "shift"}, "`", function()
  focusScreen(window.focusedWindow():screen():previous())
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

