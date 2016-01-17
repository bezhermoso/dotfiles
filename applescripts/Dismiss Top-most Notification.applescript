my closeNotification()
on closeNotification()
    tell application "System Events" to tell process "Notification Center"
        click button 1 of last item of windows
    end tell
end closeNotification
