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

      def last_element(range)
        range.exclude_end? ? range.last.pred : range.last
      end
    end
  end
end
