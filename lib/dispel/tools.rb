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

      def last_element(range)
        range.exclude_end? ? range.last.pred : range.last
      end

      # http://grosser.it/2010/12/31/ruby-string-indexes-indices-find-all-indexes-in-a-string
      def indexes(string, needle)
        found = []
        current_index = -1
        while current_index = string.index(needle, current_index+1)
          found << current_index
        end
        found
      end
    end
  end
end
