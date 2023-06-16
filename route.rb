require_relative 'modules/instance_counter.rb'

class Route
  include InstanceCounter
  attr_reader :start_station, :end_station

  def initialize(start_station, end_station)
    @start_station = start_station
    @end_station = end_station
    @in_between_stations = []
    validate!
    register_instance
  end

  def delete_station(station)
    @in_between_stations.delete station
  end

  def add_station(station)
    @in_between_stations.push station
  end

  def stations
    [@start_station] + @in_between_stations + [@end_station]
  end

  def valid?
    validate!
  rescue
    false
  end

  private

  def validate!
    if [start_station, end_station].any? { |station| !station.is_a? Station }
      raise 'Необходимы станции для создания маршрута'
    end
  end
end
