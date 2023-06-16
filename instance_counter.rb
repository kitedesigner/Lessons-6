module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end

  module InstanceMethods
    protected

    def register_instance
      self.class.instance_count ||= 0
      self.class.instance_count += 1
    end
  end

  module ClassMethods
    attr_accessor :instance_count

    def instances
      instance_count
    end
  end
end
