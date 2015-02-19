tell application "System Events"
  tell process "Atom"
    set AppleScript's text item delimiters to "\n"
    return name of windows as text
  end tell
end tell
