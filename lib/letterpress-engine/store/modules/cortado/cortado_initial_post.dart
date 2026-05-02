part of letterpress.store;

class CortadoInitialPost extends LPModule {
  CortadoInitialPost({
    required bool renderWithPost,
    required bool isPreviewMode,
  }) : super(
          isPreviewMode: isPreviewMode,
          title: "Cortado initial post",
          coverImgName: 'Infinitude',
          lastUpdate: DateTime(2024, 11, 23),
          publicationDate: DateTime(2024, 11, 23),
          tags: [],
          includeTableOfContents: false,
          components: [],
          projectName: 'cortado',
          renderWithPost: renderWithPost,
        );
}
