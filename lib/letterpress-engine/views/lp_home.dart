part of letterpress.views;

class LetterpressApp extends StatelessWidget {
  const LetterpressApp({super.key});
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: ViewportDependent(
          child: Container(
            color: OctaneTheme.obsidian800,
            width: double.infinity,
            height: double.infinity,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                      top: 50,
                      left: 10,
                    ),
                    child: Text(
                      'LET\nTER\nPRESS',
                      style: TextStyle(
                        color: OctaneTheme.obsidian100,
                        fontFamily: LPFontFamily.headers.name,
                        fontSize: 340,
                        fontWeight: FontWeight.w800,
                        height: 0.8,
                      ),
                    ),
                  ),
                  ViewportDependent(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 60,
                          right: 60,
                          top: 30,
                        ),
                        child: Column(
                          children: [
                            LPText.header1(content: 'About'),
                            const SizedBox(height: 60),
                            LPText.plainBody(
                                content:
                                    "Letterpress is a blog page by OBSiDIAN about coding and design stuff — but with a twist. Posts aren't only arranged chronologically (as a matter of fact, posts aren't even a thing!), but instead, modules are published instead."),
                            LPText.plainBody(
                                content:
                                    "Try either of the following buttons to start exploring Letterpress!"),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 200,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: OctaneTheme.purple800),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed(LPRoutes.lp_timelapse);
                                    },
                                    child: Center(
                                      child: Text(
                                        'Timelapse',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: LPFontFamily.body.name,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 1,
                                          color: OctaneTheme.purple800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 40),
                                Container(
                                  width: 200,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: OctaneTheme.purple800),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed(LPRoutes.lp_gallery);
                                    },
                                    style: TextButton.styleFrom(
                                      primary: OctaneTheme.purple800,
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
                                          color: OctaneTheme.purple800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  /* ViewportDependent(
                    child: Container(
                      width: double.infinity,
                      height: double.infinity,
                      child: Padding(
                        padding: const EdgeInsets.only(
                          left: 60,
                          right: 60,
                          top: 30,
                        ),
                        child: Column(
                          children: [
                            LPText.header1(content: 'Discover'),
                            const SizedBox(height: 60),
                            const SizedBox(height: 30),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 200,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: OctaneTheme.purple800),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed(LPRoutes.lp_timelapse);
                                    },
                                    child: Center(
                                      child: Text(
                                        'Timelapse',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontFamily: LPFontFamily.body.name,
                                          fontSize: 26,
                                          fontWeight: FontWeight.w300,
                                          letterSpacing: 1,
                                          color: OctaneTheme.purple800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 40),
                                Container(
                                  width: 200,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    border: Border.all(
                                        color: OctaneTheme.purple800),
                                  ),
                                  child: TextButton(
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pushNamed(LPRoutes.lp_gallery);
                                    },
                                    style: TextButton.styleFrom(
                                      primary: OctaneTheme.purple800,
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
                                          color: OctaneTheme.purple800,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ), */
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
