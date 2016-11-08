# holiday

## program to generate console and / or file output with holidays for certain years and regions.

### To start the program

1. Run bundle install

2. Run ruby run.rb with one or more years, e.g.
   ```ruby run.rb 2016 2017 2018```

```
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
```

Notes: 

The application generates a zip file per year in the program folder which contains the calendar template files in a fix format. Calendar files are deleted after the holiday creation and only zip files remain in the folder.


