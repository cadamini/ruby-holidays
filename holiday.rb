require 'date'
require 'time'
require 'holidays'
require 'rubygems'
require 'zip'

class Holiday
  def self.get_holidays_for(year:, region:, excluded_days:)

    holidays = Holidays.cache_between(
      Date.new(year, 1, 1), Date.new(year, 12, 31), region, :informal
    )

    # delete exluded days
    excluded_days.each do |day|
      holidays.delete_if { |m| m[:name] == day }
    end

    # potential duplicates, e.g. Reformationstag 2017
    holidays.uniq { |m| m[:name] }
  end
end

class Output
  attr_reader :year, :region_code, :region_name, :country
  def initialize(year:, region_code:, region_name:, country:)
    @year = Date.new(year)
    @region_code = region_code
    @region_name = region_name
    @country = country
  end

  def name
    "#{year.strftime('%y')}_#{region_code}.hct"
  end

  def header
    "#{year.strftime('%Y')};#{country.capitalize}, #{region_name.to_s}"
  end

  def self.generate_date_and_name(key)
    key[:date].strftime('%d.%m.%Y').to_s + ';' + key[:name].to_s
  end
end

class Result
  attr_reader :file, :holidays

  def initialize(file, holidays)
    @file = file
    @holidays = holidays
  end

  def to_archive
    Zip::File.open("#{file.year.strftime('%Y')}_templates.zip", Zip::File::CREATE) do |archive|
      to_file
      to_zip(archive)
    end
    Files.delete(:templates)
  end

  def to_console
    puts file.header
    holidays.each do |key, _|
      puts Output.generate_date_and_name(key)
    end
  end

  private

  def to_file
    File.open(file.name, 'w+') do |f|
      f.puts file.header
      holidays.each do |key, _|
        f.puts Output.generate_date_and_name(key)
      end
    end
  end

  def to_zip(archive)
    archive.add(file.name, file.name)
  end
end

class Files
  def self.delete(pattern)
    case pattern
    when :archives
      Dir['*_templates.zip'].each do |f|
        File.delete(f)
      end
    when :templates
      Dir['*.hct'].each do |f|
        File.delete(f)
      end
    end
  end
end

class TemplateFileGenerator
  attr_reader :years, :regions

  def self.run(year:, regions:, excluded_days:)
    results = []
    regions.each do |country, region|
      region.each do |region_code, region_name|
        template_file = Output.new(
            year: year,
            country: country,
            region_code: region_code,
            region_name: region_name
          )

        holidays = Holiday.get_holidays_for(year: year, region: region_code, excluded_days: excluded_days)
        results << Result.new(template_file, holidays)
      end
    end
    results
  end
end

