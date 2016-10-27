require 'date'
require 'time'
require 'holidays'
require 'rubygems'
require 'zip'

class Holiday
  def self.get_holidays_for(year:, region:)
    holidays = Holidays.cache_between(
      Date.new(year, 1, 1), Date.new(year, 12, 31), region
    )
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
    "#{year.strftime('%Y')};#{country.capitalize};#{region_name.to_s};"
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

class TemplateFileGenerator
  attr_reader :years, :regions

  def initialize(years, regions)
    @years = years
    @regions = regions
    delete_old_hct_and_zip_files
  end

  def run
    results = []
    years.each do |year|
      regions.each do |country, region|
        region.each do |region_code, region_name|
          template_file = Output.new(
              year: year,
              country: country,
              region_code: region_code,
              region_name: region_name
            )

          holidays = Holiday.get_holidays_for(year: year, region: region_code)
          results << Result.new(template_file, holidays)
        end
      end
    end
    results
  end

  private

  def delete_old_hct_and_zip_files
    Dir['*.hct', '*_templates.zip'].each do |f|
      File.delete(f)
    end
  end
end

# main program example

regions = {
  deutschland:
  {
    de: 'Gesamt',
    de_sn: 'Sachsen',
    de_bb: 'Brandenburg',
    de_bw: 'Baden-Württemberg',
    de_by: 'Bayern',
    de_he: 'Hessen',
    de_mv: 'Mecklenburg-Vorpommern',
    de_nw: 'Nordrhein-Westfalen',
    de_rp: 'Rheinland-Pfalz',
    de_sl: 'Saarland',
    de_st: 'Sachsen-Anhalt',
    de_th: 'Thürigen'
  },
  frankreich:
  {
    fr: 'Gesamt'
  }
}

result = TemplateFileGenerator.new([2016, 2017], regions).run
result.each do |output|
  output.to_console
  output.to_archive
end
