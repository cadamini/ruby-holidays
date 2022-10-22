## Generate console or file output with holidays for certain years and regions

1. Clone the repo.
2. Run `bundle install`.
3. Start the run.rb file with one or more years:
   ```ruby run.rb 2016 2017 2018```

### Configuration

Configure different options directly in the code:

**Regions**

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
```

**Output**

```
output.to_console # optional
output.to_archive
```

The application created one zip file per year. 

You have to delete the files manually.

