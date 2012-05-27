require 'simplecov'

Dir["../src/*.rb"].each {|file| require file }

SimpleCov.start