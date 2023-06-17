class PassengerTrain < Train
  def initialize(name)
    super(name, :passenger)
  end

  def attachable_wagon?(wagon)
    wagon.is_a?(PassengerWagon)
  end
end
