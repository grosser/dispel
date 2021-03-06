require 'curses'

module Dispel
  class Screen
    attr_accessor :options

    def initialize(options)
      @options = options
      @cache = []
    end

    def self.open(options={}, &block)
      new(options).open(&block)
    end

    def open(&block)
      Curses.noecho # do not show typed chars
      Curses.nonl # turn off newline translation
      Curses.stdscr.keypad(true) # enable arrow keys
      Curses.raw # give us all other keys
      Curses.stdscr.nodelay = 1 # do not block -> we can use timeouts
      Curses.init_screen
      Curses.start_color if color?
      yield self
    ensure
      Curses.clear # needed to clear the menu/status bar on windows
      Curses.close_screen
    end

    def columns
      Curses.stdscr.maxx
    end

    def lines
      Curses.stdscr.maxy
    end

    def draw(view, style_map=[], cursor=[0,0])
      @cache.clear if dimensions_changed?
      draw_view(view, style_map)
      Curses.setpos(*cursor) # cursor has to always be set or it ends in random position
    end

    def debug_key(key)
      @key_line ||= -1
      @key_line = (@key_line + 1) % lines
      write(@key_line, 0, "#{key.inspect}---")
    end

    def color?
      @options[:colors] and Curses.has_colors?
    end

    private

    def write(line,row,text)
      Curses.setpos(line,row)
      Curses.addstr(text);
    end

    def draw_view(view, style_map)
      lines = Tools.naive_split(view, "\n")
      style_map = style_map.flatten

      lines.each_with_index do |line, line_number|
        styles = style_map[line_number]

        # expand line with whitespace to overwrite previous content
        # and remove overflow to avoid display errors
        line = line.ljust(columns, " ").slice!(0, columns)

        # display tabs as single-space -> nothing breaks
        line.gsub!("\t",' ')

        if_line_changes line_number, [line, styles] do
          # position at start of line and draw
          Curses.setpos(line_number,0)
          Dispel::StyleMap.styled(line, styles).each do |style, part|
            Curses.attrset curses_style(style)
            Curses.addstr part
          end

          if @options[:debug_cache]
            write(line_number, 0, (rand(899)+100).to_s)
          end
        end
      end
    end

    def if_line_changes(key, args)
      return if @cache[key] == args # would not change the line -> nothing to do
      @cache[key] = args # store current line
      yield # render the line
    end

    def dimensions_changed?
      current_dimensions = [columns, lines]
      @old_dimensions != current_dimensions
      @old_dimensions = current_dimensions
    end

    def curses_style(style)
      @style ||= {}
      @style[style] ||= self.class.curses_style(style, color?, options)
    end

    class << self
      def curses_style(style, colors, options={})
        if colors
          foreground = options[:foreground] || '#ffffff'
          background = options[:background] || '#000000'

          foreground, background = if style == :normal
            [foreground, background]
          elsif style == :reverse
            ['#000000', '#ffffff']
          else
            # :red or [:red, :blue]
            f,b = style
            [f || foreground, b || background]
          end

          foreground = html_to_terminal_color(foreground)
          background = html_to_terminal_color(background)
          color_id(foreground, background)
        else # no colors
          if style == :reverse
            Curses::A_REVERSE
          else
            Curses::A_NORMAL
          end
        end
      end

      # create a new color from foreground+background or reuse old
      # and return color-id
      def color_id(foreground, background)
        @color_ids ||= {}
        @color_ids[[foreground, background]] ||= begin
          # make a new pair with a unique id
          @@max_color_id ||= 0
          id = (@@max_color_id += 1)
          unless defined? RSpec # stops normal text-output, do not use in tests
            Curses::init_pair(id, foreground, background)
          end
          Curses.color_pair(id)
        end
      end

      COLOR_SOURCE_VALUES = 256
      COLOR_TARGET_VALUES = 5
      COLOR_DIVIDE = COLOR_SOURCE_VALUES / COLOR_TARGET_VALUES
      TERM_COLOR_BASE = 16

      def html_to_terminal_color(html_color)
        return unless html_color
        r = (html_color[1..2].to_i(16) / COLOR_DIVIDE) * 36
        g = (html_color[3..4].to_i(16) / COLOR_DIVIDE) * 6
        b = (html_color[5..6].to_i(16) / COLOR_DIVIDE) * 1
        TERM_COLOR_BASE + r + g + b
      end
    end
  end
end
