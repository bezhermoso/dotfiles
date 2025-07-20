if application "Ghostty" is running then
    tell application "Ghostty" to activate
    delay 0.5
    tell application "System Events"
        keystroke "r" using command down
    end tell
end if
