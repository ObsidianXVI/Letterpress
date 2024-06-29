part of letterpress.ds;

enum LPFontFamily {
  headers('Fraunces_Standard'),
  body('Fraunces_Soft');

  final String name;
  const LPFontFamily(this.name);
}

enum LPColorTheme {
  background_grey(OctaneTheme.obsidianD150),
  standard_grey(OctaneTheme.obsidianA150),
  header1_grey(OctaneTheme.obsidianB000),
  header2_grey(OctaneTheme.obsidianB050),
  header3_grey(OctaneTheme.obsidianB100),
  header4_grey(OctaneTheme.obsidianB150),
  hyperlink_purple(OctaneTheme.purple800),
  inline_code_cyan(OctaneTheme.blue800),
  lyrics_quote_red(OctaneTheme.red800),
  ;

  final Color color;
  const LPColorTheme(this.color);
}

