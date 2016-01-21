local pathwatcher = require "hs.pathwatcher"

--Straight out of the docs.
--http://www.hammerspoon.org/go/#fancyreload
local function reloadConfig(files)
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
