Remove evil curses

Install
=======

    gem install dispel

Usage
=====

<!-- example -->
```Ruby
require 'dispel'

# draw app and redraw after each keystroke
Dispel::Screen.open do |screen|
  screen.draw "Initial state, press any key!\n\n   Oh boy!"

  Dispel::Keyboard.output do |key|
    case key
    when :resize then screen.clear_cache
    when :"Ctrl+c" then break
    end

    screen.draw "Looks like you pressed #{key} (Ctrl+c to quit)"
  end
end
```
<!-- example -->


Author
======
[Michael Grosser](http://grosser.it)<br/>
michael@grosser.it<br/>
License: MIT<br/>
[![Build Status](https://travis-ci.org/grosser/dispel.png)](https://travis-ci.org/grosser/dispel)
