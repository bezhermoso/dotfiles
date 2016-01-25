local window = require "hs.window"
local screen = require "hs.screen"
local hotkey = require "hs.hotkey"
local fnutils = require "hs.fnutils"
require "hs.application"

-- DISPLAY FOCUS SWITCHING --

--One hotkey should just suffice for dual-display setups as it will naturally
--cycle through both.
--A second hotkey to reverse the direction of the focus-shift would be handy
--for setups with 3 or more displays.

--Predicate that checks if a window belongs to a screen
local function isInScreen(screen, win)
  return win:screen() == screen
end

local function focusScreen(screen)
  --Get windows within screen, ordered from front to back.
  --If no windows exist, bring focus to desktop. Otherwise, set focus on
  --front-most application window.
  local windows = fnutils.filter(
    window.orderedWindows(),
    fnutils.partial(isInScreen, screen))
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
