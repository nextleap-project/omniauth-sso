require 'simplecov'
SimpleCov.start do
  add_filter "/test/"
  add_filter "/vendor/ruby"
end

require 'minitest/autorun'
