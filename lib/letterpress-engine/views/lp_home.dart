part of letterpress.views;

class LetterpressApp extends StatelessWidget {
  const LetterpressApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Container(
            width: DimensionTools.getWidth(context),
            height: DimensionTools.getHeight(context),
            color: LPTheme.grey800,
            child: Stack(
              children: [
                const Positioned.fill(
                  child: SizedBox(
                    width: 800,
                    height: 800,
                    child: Image(
                      image: AssetImage('images/letterpress_3.png'),
                      opacity: AlwaysStoppedAnimation(0.5),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SelectionArea(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(height: 200),
                        LPText.header1(
                          content: 'Letterpress',
                          alignment: Alignment.center,
                        ),
                        const SizedBox(height: 120),
                        LPTextSpan(
                          lpTextComponents: [
                            LPText.plainBody(content: 'A blogging site by '),
                            LPText.hyperlink(
                              content: 'OBSiDIAN',
                              url: 'https://github.com/ObsidianXVI',
                            ),
                            LPText.plainBody(
                              content: ' about coding, design, and the likes.',
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          height: 100,
                          child: ListView(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            children: [
                              Center(
                                child: SelectionContainer.disabled(
                                  child: Container(
                                    width: 200,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border:
                                          Border.all(color: LPTheme.purple800),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(LPRoutes.tgif_home);
                                      },
                                      style: TextButton.styleFrom(
                                        primary: LPTheme.purple800,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'TGIF Challenge',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: LPFontFamily.body.name,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w300,
                                            letterSpacing: 1,
                                            color: LPTheme.purple800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 50),
                              Center(
                                child: SelectionContainer.disabled(
                                  child: Container(
                                    width: 200,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: LPTheme.purple800
                                              .withOpacity(0.4)),
                                    ),
                                    child: TextButton(
                                      onPressed: null,
                                      child: Center(
                                        child: Text(
                                          'Timelapse Series',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: LPFontFamily.body.name,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w300,
                                            letterSpacing: 1,
                                            color: LPTheme.purple800
                                                .withOpacity(0.4),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 50),
                              Center(
                                child: SelectionContainer.disabled(
                                  child: Container(
                                    width: 200,
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border:
                                          Border.all(color: LPTheme.purple800),
                                    ),
                                    child: TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushNamed(LPRoutes.lp_gallery);
                                      },
                                      style: TextButton.styleFrom(
                                        primary: LPTheme.purple800,
                                      ),
                                      child: Center(
                                        child: Text(
                                          'Gallery',
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            fontFamily: LPFontFamily.body.name,
                                            fontSize: 26,
                                            fontWeight: FontWeight.w300,
                                            letterSpacing: 1,
                                            color: LPTheme.purple800,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }
}