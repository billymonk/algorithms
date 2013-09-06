# Ruby implementation of Manacher's linear-time algorithm for finding
# the longest palindromic substring in a string.
#
# Adapted from http://www.akalin.cx/longest-palindrome-linear-time.

require 'test/unit'

class Manacher
  class << self
    def find_longest(string)
      string_length = string.length
      l = []
      i = 0
      pal_len = 0

      while i < string_length do
        found_match = false

        if i > pal_len && string[i - pal_len - 1] == string[i]
          pal_len += 2
          i += 1

          next
        end

        l.push(pal_len)

        s = l.length - 2
        e = s - pal_len
        s.downto(e + 1) do |j|
          d = j - e - 1

          if l[j] == d
            pal_len = d
            found_match = true
            break
          end

          l.push([d, l[j]].min)
        end

        unless found_match
          pal_len = 1
          i += 1
        end
      end

      l.push(pal_len)

      l_len = l.length
      s = l_len - 2
      e = s - (2 * string_length + 1 - l_len)

      s.downto(e + 1) do |i|
        d = i - e - 1
        l.push([d, l[i]].min)
      end

      l
    end
  end
end

class TestManacher < Test::Unit::TestCase
  def test_empty_string
    assert_equal(Manacher.find_longest(""), [0])
  end

  def test_simple_string
    assert_equal(Manacher.find_longest("abba"), [0, 1, 0, 1, 4, 1, 0, 1, 0])
  end

  def test_complicated_symmetrical_string
    assert_equal(Manacher.find_longest("abcdefghijklmnopqrstuvwxyzzyxwvutsrqponmlkjihgfedcba"), [0, 1, 0, 1, 0,
                 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
                 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 52, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
                 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0])
  end

  def test_simple_nonsymmetrical_string
    assert_equal(Manacher.find_longest("abcbillyyllib"), [0, 1, 0, 1, 0, 3, 0, 1, 0, 1, 0, 1, 2, 1, 0, 1, 10,
                 1, 0, 1, 2, 1, 0, 1, 0, 1, 0])
  end

  def test_complicated_nonsymmetrical_string
    assert_equal(Manacher.find_longest("abcdefghijklmnopqrstuvwxyzpalindromeemordnilapwxyz"), [0, 1, 0, 1, 0,
                 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0,
                 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1,
                 0, 1, 20, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0, 1, 0])
  end
end
