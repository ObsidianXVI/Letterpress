part of letterpress.store;

final LPPost turbocal_post = LPPost(
  postConfigs: LPPostConfigs(
      title: 'Complex Calendar Widget in Flutter (Turbocal)',
      description:
          'Designing a Google Calendar-like widget from scratch in Flutter.',
      publicationDate: DateTime(2023, 3, 10),
      lastUpdate: DateTime(2023, 6, 2),
      includeTableOfContents: true,
      modules: [
        TurbocalModuleA(renderWithPost: true),
      ]),
);
