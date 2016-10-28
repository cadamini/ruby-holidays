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
  }
}

Files.delete(:archives)
ARGV.each do |args|
  result = TemplateFileGenerator.run(year: args.to_i, regions: regions)
  result.each do |output|
    output.to_console # optional
    output.to_archive
  end
end
