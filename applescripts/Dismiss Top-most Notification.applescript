my closeNotification()
on closeNotification()
    tell application "System Events" to tell process "Notification Center"
      try
        click button 1 of first item of windows
      end try
    end tell
end closeNotification
