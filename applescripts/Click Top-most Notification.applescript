my clickNotification()
on clickNotification()
    tell application "System Events" to tell process "Notification Center"
        click last item of windows
    end tell
end clickNotification
