my secondaryClickNotification()
on secondaryClickNotification()
    tell application "System Events" to tell process "Notification Center"
      try
        click button 2 of last item of windows
      end try
    end tell
end secondaryClickNotification
