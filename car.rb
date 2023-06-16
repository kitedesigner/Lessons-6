require_relative '../modules/manufacturer.rb'
class Car
  include Manufacturer
  attr_reader :type
end
