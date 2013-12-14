$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'dispel'

# draw app and redraw after each keystroke
Dispel::Screen.open do |screen|
  screen.draw "Initial state, press any key!", [], [0,0]

  Dispel::Keyboard.input do
    Curses.getch
  end

  Dispel::Keyboard.output do |key|
    case key
    when :resize then screen.clear_cache
    when :"Ctrl+c" then break
    end

    screen.draw "Looks like you pressed #{key} (Ctrl+c to quit)", [], [0,0]
  end
end
