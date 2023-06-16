require_relative 'modules/instance_counter.rb'

class Station
  include InstanceCounter
  attr_reader :trains, :name

  @@stations = []
  def self.all
    @@stations
  end
  def initialize(name)
    @name = name
    @trains = []
    validate!
    @@stations << self
    register_instance
  end

  def arrival(train)
    @trains.push train
  end

  def departure(train)
    @trains.delete train
  end

  def valid?
    validate!
  rescue
    false
  end

  private

  def validate!
    raise 'Название не может быть пустым' if name.empty?
  end
end
