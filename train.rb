require_relative '../modules/manufacturer.rb'
require_relative '../modules/instance_counter.rb'
class Train
  include Manufacturer
  include InstanceCounter
  attr_reader :speed, :type, :route, :current_station_index, :number

  @@trains = []
  def self.find(number)
    @@trains.find { |train| train.number == number }
  end

  def initialize(number)
    @number = number
    @cars = []
    @speed = 0
    validate!
    @@trains << self
    register_instance
  end

  def increase_speed
    @speed += 10
  end

  def stop_train
    @speed = 0
  end

  def add_car(car)
    @cars << car if speed == 0 && car.type == type
  end

  def unhook_car
    @cars.pop
  end

  def assign_route(route)
    @route = route
    route.start_station.arrival self
    @current_station_index = 0
  end

  def go_to_next_station
    if next_station
      current_station.departure self
      @current_station_index += 1
      current_station.arrival self
    end
  end

  def go_to_previous_station
    if previous_station
      current_station.departure self
      @current_station_index -= 1
      current_station.arrival self
    end
  end

  def valid?
    validate!
  rescue
    false
  end

  private

  def next_station
    route.stations[current_station_index + 1]
  end

  def previous_station
    route.stations[current_station_index - 1]
  end

  def current_station
    route.stations[current_station_index]
  end

  def validate!
    raise 'Введенный номер не соответствует формату' if number !~ /[A-zА-я0-9]{3}-?[A-zА-я0-9]{2}/
  end
end
