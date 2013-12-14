module Dispel
  module Tools
    class << self
      # http://grosser.it/2011/08/28/ruby-string-naive-split-because-split-is-to-clever/
      # "    ".split(' ') == []
      # "    ".naive_split(' ') == ['','','','']
      # "".split(' ') == []
      # "".naive_split(' ') == ['']
      def naive_split(string, pattern)
        pattern = /#{Regexp.escape(pattern)}/ unless pattern.is_a?(Regexp)
        result = string.split(pattern, -1)
        result.empty? ? [''] : result
      end

      def memoize(*args)
        key = args.map(&:to_s).join("-")
        @memoize ||= {}
        if @memoize.key?(key)
          @memoize[key]
        else
          @memoize[key] = yield
        end
      end

      # so far the only terminal that supports it:
      # - xterm-256color on osx
      # - xterm and xterm-256color on ubuntu 10.04+
      # (setting ENV['TERM'] will sometimes crash un-rescue-able -> test if it works)
      def activate_256_colors
        require 'ruco/file_store'
        (
          # not windows
        RbConfig::CONFIG['host_os'] !~ /mswin|mingw/ and

          # possible to open xterm-256color
          ['xterm', 'xterm-256color'].include?(ENV['TERM']) and
          Ruco::FileStore.new('~/.ruco/cache').cache('color_possible'){
            system(%{TERM=xterm-256color ruby -r curses -e 'Curses.noecho' > /dev/null 2>&1})
          }

        # finally switch terminal, so curses knows we want colors
        ) and ENV['TERM'] = 'xterm-256color'
      end
    end
  end
end
