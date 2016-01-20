my clickNotification()
on clickNotification()
	tell application "System Events" to tell process "Notification Center"
		try
			click last item of windows
		end try
	end tell
end clickNotification
