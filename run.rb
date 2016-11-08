require_relative 'holiday'

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
  },
  england:
  {
    gb: 'Gesamt'
  },
  america:
  {
    us: 'Gesamt'
  }
}

# as the library returns informal holidays as well, we need to exclude some
excluded_days = [
  'Heilig Abend', 'Weiberfastnacht', 'Rosenmontag', 'Aschermittwoch', # de*
  "April Fool's Day", "Valentine's Day", "Father's Day" # us
]

Files.delete(:archives)
ARGV.each do |args|
  result = TemplateFileGenerator.run(year: args.to_i, regions: regions, excluded_days: excluded_days)
  result.each do |output|
    output.to_console # optional
    output.to_archive
  end
end
