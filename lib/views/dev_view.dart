part of letterpress.views;

class DevView extends StatelessWidget {
  const DevView({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(40),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Main Title',
                    style: LPFont.mainTitle(textColor: OctaneTheme.obsidianD150)
                        .textStyle,
                  ),
                  Text(
                    'Sub Title',
                    style: LPFont.subTitle(textColor: OctaneTheme.obsidianD150)
                        .textStyle,
                  ),
                  Text(
                    'Header 1',
                    style: LPFont.header1(textColor: OctaneTheme.obsidianD150)
                        .textStyle,
                  ),
                  Text(
                    'Header 2',
                    style: LPFont.header2(textColor: OctaneTheme.obsidianD150)
                        .textStyle,
                  ),
                  Text(
                    'Header 3',
                    style: LPFont.header3(textColor: OctaneTheme.obsidianD150)
                        .textStyle,
                  ),
                  Text(
                    'Header 4',
                    style: LPFont.header4(textColor: OctaneTheme.obsidianD150)
                        .textStyle,
                  ),
                  Text(
                    'Body',
                    style: LPFont.body(textColor: OctaneTheme.obsidianD150)
                        .textStyle,
                  ),
                  Text(
                    'Button',
                    style: LPFont.body(textColor: OctaneTheme.obsidianD150)
                        .textStyle,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
