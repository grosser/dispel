$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require 'dispel'

# draw app and redraw after each keystroke
Dispel::Screen.open(:color => true) do |screen|
  map = Dispel::StyleMap.new(3)
  map.add(:reverse, 0, 1..5)
  map.add(["#aa0000", "#00aa00"], 0, 5..8)

  screen.draw "Shiny Rainbows!\nDefault\nand more!", map, [0,3]

  Dispel::Keyboard.output { break }
end
