part of letterpress.store;

class A_Formal_Intro_To_Lh extends LPModule {
  A_Formal_Intro_To_Lh({required bool renderWithPost})
      : super(
          title: "A formal introduction to Lighthouse",
          lastUpdate: DateTime(2023, 9, 4),
          publicationDate: DateTime(2023, 9, 4),
          tags: [],
          includeTableOfContents: true,
          components: [
            LPText.plainBody(
                content:
                    """Lighthouse is a project I started in June 2022, 3 months after I first started coding. Even though Lighthouse was my first coding project (I had never completed even a single mini-project while learning to code), I wanted to go big."""),
          ],
          projectName: 'lighthouse',
          renderWithPost: renderWithPost,
        );
}
