# holiday

## program to generate console and / or file output with holidays for certain years and regions.

### main program example
```
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

result = TemplateFileGenerator.run(years: [2016, 2017], regions: regions)
result.each do |output|
  output.to_console # optional
  output.to_archive
end
```

The application generates a zip file per year in the program folder which contains the calendar template files in a fix format.



