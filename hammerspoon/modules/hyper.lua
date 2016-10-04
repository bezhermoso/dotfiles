--HYPER-KEY (F18) BINDINGS
local k = hs.hotkey.modal.new({}, "F17")

-- Taken from https://github.com/lodestone/hyper-hacks/blob/master/hammerspoon/init.lua
-- Enter Hyper Mode when F18 (Hyper/Capslock) is pressed
local pressedF18 = function()
  k.triggered = false
  k:enter()
end

-- Leave Hyper Mode when F18 (Hyper/Capslock) is pressed,
--   send ESCAPE if no other keys are pressed.
local releasedF18 = function()
  k:exit()
  if not k.triggered then
    hs.eventtap.keyStroke({}, 'ESCAPE')
  end
end

-- Bind the Hyper key
local f18 = hs.hotkey.bind({}, 'F18', pressedF18, releasedF18)
