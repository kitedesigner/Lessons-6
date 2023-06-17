require_relative 'station.rb'
require_relative 'route.rb'
require_relative 'train.rb'
require_relative 'wagon.rb'
require_relative 'passenger_train.rb'
require_relative 'cargo_train.rb'
require_relative 'passenger_wagon.rb'
require_relative 'cargo_wagon.rb'
require_relative 'menu_items.rb'

class MainMenu
  include MenuItems

  def initialize
    @stations = []
    @trains = []
    @wagons = []
    @routes = []
  end

  def start
    loop do
      show_menu
    end
  end

  def show_menu
    choices_list(SHOW_MENU_LIST, true)
    case gets.to_i
    when 1 then stations_menu
    when 2 then trains_menu
    when 3 then create_route_menu
    when EXIT then exit
    else enter_another_value
    end
  end

  private

  def stations_menu
    loop do
      stations_menu_intro
      choices_list(STATIONS_MENU_LIST, true)
      case gets.to_i
      when 1 then create_station
      when 2 then stations_list
      when 3 then break
      when EXIT then exit
      else enter_another_value
      end
    end
  end

  def trains_menu
    loop do
      trains_menu_intro
      choices_list(TRAINS_MENU_LIST, true)
      case gets.to_i
      when 1 then create_train
      when 2 then set_train_route
      when 3 then wagons_menu_for_train
      when 4 then move_train_menu
      when 5 then stations_and_trains
      when 6 then break
      when EXIT then exit
      else enter_another_value
      end
    end
  end

  # Для вызова из корневого меню
  def create_route_menu
    loop do
      create_route_intro
      case gets.to_i
      when 1 then create_route
      when 2 then add_route_station
      when 3 then delete_route_station
      when 4 then routes_list
      when 5 then break
      when EXIT then exit
      else enter_another_value
      end
    end
  end

  # Для вызова из корневого меню
  def wagons_menu
    loop do
      choices_list(WAGON_MENU_LIST, true)
      case gets.to_i
      when 1 then create_wagon
      when 2 then break
      when EXIT then exit
      else enter_another_value
      end
    end
  end

  # Для вызова из меню поездов
  def wagons_menu_for_train
    train = select_train
    loop do
      if @trains.empty? then
        puts CREATE_TRAIN_MESSAGE
        break
      end
      choices_list(WAGON_ADD_UNHOOK_MENU_LIST, BACK_TO_TRAIN_MANAGEMENT_MESSAGE)
      case gets.to_i
      when 1
        enter_number_wagon_message
        number = gets.to_i
        wagon = create_wagon_for_train(train, number)
        train.add_wagon(wagon)
        add_wagon(wagon)
      when 2
        enter_number_wagon_message
        print_wagons_in_train(train)
        wagon = select_from_list(train.wagons)
        train.remove_wagon(wagon)
        print_wagons_in_train(train)
      when 3
        break
      else
        enter_another_value
      end
    end
  end

  def move_train_menu
    loop do
      train = select_train
      choices_list(MOVE_TRAIN_MENU_LIST, true)
      case gets.to_i
      when 1 then train.move_to_next_station
      when 2 then train.move_to_previous_station
      when 3 then break
      else enter_another_value
      end
    end
  end


  def create_station
    print INPUT_NAME_STATION_MESSAGE # 'Введите название новой станции: '
    name = gets.chomp
    return print STATION_EXISTS_MESSAGE if station_exist?(name)
    @stations << Station.new(name)
    station_created_message(name)
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def station_exist?(name)
    !!@stations.detect {|station| station.name == name}
  end

  def create_train
    print ENTER_NAME_NEW_TRAIN_MESSAGE # 'Введите наименование нового поезда: '
    number = gets.chomp
    #return print ENTER_ANOTHER_NUMBER_MESSAGE if train_exist?(name)
    return print ENTER_ANOTHER_NUMBER_MESSAGE if train_exist?(number)
    create_train_by_type(name)
    train_created_message(name)
  rescue RuntimeError => e
    puts e.message
    retry
  end

  def create_train_by_type(name)
    loop do
      choices_list(CREATE_TRAIN_BY_TYPE_MENU_LIST, false)
      case gets.to_i
      when 1
        @trains << PassengerTrain.new(name)
        break
      when 2
        @trains << CargoTrain.new(name)
        break
      else
        enter_another_value
      end
    end
  end

  def train_exist?(number)
    !!@trains.detect {|train| train.number == number}
  end

  def select_train
    puts TRAIN_LIST_MESSAGE
    trains_list
    selected_train = select_from_list(@trains)
    if selected_train.to_s.empty?
      puts ENTER_CORRECTION_NUMBER_TRAIN_MESSAGE # 'Введите правильный номер поезда и повторите попытку.'
    else
      return selected_train
    end
  end

  # Вспомогательные методы для вагонов
  def create_wagon_for_train(train, number)
    train.type == :cargo ? CargoWagon.new(number) : PassengerWagon.new(number)
  end

  def trains_list
    @trains.each_with_index do |train, index|
      puts "#{index} - Наименование поезда - #{train.name}"
    end
  end

  def stations_list
    @stations.each_with_index do |stations, index|
      puts "#{index} - Наименование станции - #{stations.name}"
    end
    blank_line
  end

  def routes_list
    routes = []
    @routes.each do |route|
      routes << "Маршрут номер #{@routes.index(route)}"
    end
    blank_line
    puts routes.join(', ')
  end

  def stations_and_trains
    puts STATIONS_LIST_MESSAGE # 'Список станций: '
    @stations.each do |station|
      if !station.trains.empty?
        trains = []
        station.trains.each do |train|
          trains << train.name
        end
        puts "Станция #{station.name}, поезда: #{trains.join(', ')}"
      else
        puts "Станция #{station.name}"
      end
    end
    puts LIST_OF_TRAINS_MESSAGE # 'Общий список поездов:'
    trains_list
  end

  def print_stations_in_route(route)
    route.stations.each_with_index do |stations, index|
      puts "#{index} - Наименование станции - #{stations.name}"
    end
  end

  def print_wagons_in_train(train)
    train.wagons.each_with_index do |wagon, index|
      puts "#{index} - Номер вагона #{wagon.number}"
    end
  end

  def add_wagon(wagon)
    @wagons << wagon
  end

  def add_route(route)
    @routes << route
  end

  def create_route
    if @stations.empty?
      print CREATE_STATIONS_MESSAGE
    else
      begin
        puts STATIONS_LIST_MESSAGE # 'Список станций: '
        stations_list
        print ENTER_ID_FIRST_STATION # 'Введите номер первой станции: '
        first_station = select_from_list(@stations)
        print ENTER_ID_SECOND_STATION # 'Введите номер второй станции: '
        last_station = select_from_list(@stations)
        return show_error if first_station.nil? || last_station.nil?
        return show_error if first_station == last_station
        @routes << Route.new(first_station, last_station)
        route_created_message
      rescue RuntimeError => e
        puts e.message
        retry
      end
    end
  end

  def set_train_route
    puts TRAINS_LIST_MESSAGE
    trains_list
    train = select_from_list(@trains)
    puts ROUTE_LIST_MESSAGE
    routes_list
    route = select_from_list(@routes)
    return if train.nil? || route.nil?
    train.set_route(route)
  end

  def delete_route_station
    puts ROUTE_LIST_MESSAGE
    routes_list
    route = select_from_list(@routes)
    puts STATIONS_LIST_MESSAGE
    print_stations_in_route(route)
    station = select_from_list(@stations)
    route.delete_station(station)
  end

  def add_route_station
    puts ROUTE_LIST_MESSAGE
    routes_list
    route = select_from_list(@routes)
    puts STATIONS_LIST_MESSAGE
    stations_list
    station = select_from_list(@stations)
    return show_error if route.nil? || station.nil? #проверка
    route.add_station(station) #добавляем
  end

  def select_from_list(array)
    puts SELECT_NUMBER
    number = gets.to_i
    array[number]
  end
end
