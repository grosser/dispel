Remove evil curses

Install
=======

```Bash
gem install dispel
```

Usage
=====

### Black and white
<!-- example echo -->
```Ruby
require 'dispel'

# draw app and redraw after each keystroke
Dispel::Screen.open do |screen|
  screen.draw "Initial state, press any key!\n\n   Oh boy!"

  Dispel::Keyboard.output do |key|
    break if key == :"Ctrl+c"
    screen.draw "Looks like you pressed #{key} (Ctrl+c to quit)"
  end
end
```
<!-- example -->

### Colors
<!-- example colors -->
```Ruby
require 'dispel'

# draw app and redraw after each keystroke
Dispel::Screen.open(colors: true) do |screen|
  map = Dispel::StyleMap.new(3) # number of lines
  map.add(:reverse, 0, 1..5)    # :normal / :reverse / color, line, characters
  map.add(["#aa0000", "#00aa00"], 0, 5..8) # foreground red, background green

  screen.draw "Shiny Rainbows!\nDefault\nand more!", map, [0,3] # text, styles, cursor position

  Dispel::Keyboard.output { break }
end
```
<!-- example -->

### Periodical refresh
<!-- example timeout -->
```Ruby
require 'dispel'

# draw app and redraw after each keystroke
Dispel::Screen.open do |screen|
  Dispel::Keyboard.output timeout: 0.5 do |key|
    if key == :timeout
      screen.draw "The time is #{Time.now}"
    elsif key == :"Ctrl+c"
      break
    else
      screen.draw "You pressed #{key}"
    end
  end
end
```
<!-- example -->

# Example applications
 - [ruco](https://github.com/grosser/ruco)
 - [tic_tac_toe](https://github.com/grosser/tic_tac_toe)
 - [a-panzer](https://github.com/grosser/a-panzer)

# TODO
 - resize event should triggered instantly after resizing, not after first key press

Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/dispel.png)](https://travis-ci.org/grosser/dispel)
