my secondaryClickNotification()
on secondaryClickNotification()
    tell application "System Events" to tell process "Notification Center"
        click button 2 of last item of windows
    end tell
end secondaryClickNotification
