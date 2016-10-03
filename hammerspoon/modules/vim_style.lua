-- Taken from https://github.com/tekezo/Karabiner-Elements/issues/103#issuecomment-250225961, with some fixes (`local k = ...`).
local function trigger(key)
  local k = key
  return function()
    hs.eventtap.keyStroke({}, k)
  end
end

hs.hotkey.bind({"ctrl"}, 'h', trigger('left'), nil, trigger('left'))
hs.hotkey.bind({"ctrl"}, 'j', trigger('down'), nil, trigger('down') )
hs.hotkey.bind({"ctrl"}, 'k', trigger('up') , nil, trigger('up') )
hs.hotkey.bind({"ctrl"}, 'l', trigger('right'), nil, trigger('right') )
