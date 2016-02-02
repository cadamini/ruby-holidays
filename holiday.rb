require 'date'
require 'time'
require 'holidays'

class Holiday
  def self.get
    puts Holidays.cache_between(Time.now, Time.new(2017), :ca, :us, :observed)
  end

  def self.load_generated_definitions
    Holidays.load_all
  end

  def self.regions
    Holidays.regions
  end
end

Holiday.regions
