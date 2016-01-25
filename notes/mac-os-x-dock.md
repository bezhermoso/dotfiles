## Notes on Mac OS X Dock customization

1. Add more dock separators:

`defaults write com.apple.dock persistent-apps -array-add '{"tile-type"="spacer-tile";}'; killall Dock`

2. Theme and customize Dock:

    * Install [cDock2](https://github.com/w0lfschild/cDock2)_
    * Requires SIP disable.
