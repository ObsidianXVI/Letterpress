part of letterpress.store;

class SkeletonsGoldChestsAndOtherSwashbucklingTreasures extends LPModule {
  SkeletonsGoldChestsAndOtherSwashbucklingTreasures(
      {required bool renderWithPost})
      : super(
          isPreviewMode: true,
          title: "Skeletons, gold chests, and other swashbuckling treasures",
          coverImgName: 'Serendipity',
          lastUpdate: DateTime(2024, 9, 16),
          publicationDate: DateTime(2024, 9, 16),
          tags: [],
          includeTableOfContents: false,
          components: [
            LPText.plainBody(
                content:
                    "We will set up our codebase with some basic boilerplate code, delighting in the effortless flurry of keystrokes to declare stateful widgets and final variables — the commonplace treasures one comes across on any Flutter adventure."),
            LPText.header1(content: "The Turbocal Widget Tree"),
            LPText.plainBody(
                content:
                    "After much experimenting, this is the widget tree that I deemed ideal, balancing code maintainability while also accommodating all the necessary functions that we want our calendar to have:"),
            LPImage.asset(
              assetPath: 'assets/images/turbocal/1-call-stack-flowchart-content.png',
              width: 700,
              height: 700,
            ),
            LPText.plainBody(
                content:
                    "Wait! Don't panic! Here's a visual annotation of some of the widgets to give you a better idea of what's going on."),
            LPImage.asset(
              assetPath:
                  'assets/images/turbocal/2-tcinstance-hierarchy-annotation.png',
              width: 700,
              height: 700,
            ),
            LPText.plainBody(
                content: "Let's have a quick look at each part of the tree."),
            LPText.header1(content: "TCInstance"),
            LPText.plainBody(
                content:
                    "- the root widget that the user creates to insert a Turbocal in their application\n- contains styling and layout configs\n- contains the event data (discussed later on)"),
            LPText.hyperlink(
              content: 'Lighthouse',
              route:
                  '${LPRoutes.lp_blogules}/${LPStore.lhAFormalIntroToLh.title.urlSafeSlug}',
            ),
          ],
          projectName: 'turbocal',
          renderWithPost: renderWithPost,
        );
}
