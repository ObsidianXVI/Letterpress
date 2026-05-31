part of letterpress.store;

class Create_Art_Not_Code extends LPModule {
  Create_Art_Not_Code({required bool renderWithPost})
    : super(
        title: "You're creating art, not writing code",
        coverImgName: 'Infinitude',
        lastUpdate: DateTime(2024, 11, 23),
        publicationDate: DateTime(2024, 11, 23),
        tags: [],
        includeTableOfContents: false,
        components: [
          const LPPullQuote(content: "The design process is iterative."),
          LPText.plainBody(
            content:
                "This is an oft-repeated mantra of designers, architects, developers, and — more broadly speaking — any profession involving an artistic endeavour. “But wait a minute”, you say. Software development? An artistic endeavour? Well, I genuinely believe that the process of software design is really akin to that which a painter undergoes before producing the end result, a painting on a canvas. And it might seem ironic at first that such a nerdy and geeky undertaking might even be placed together in the same sentence as the subtle, aesthetically-pleasing, and soul-feeding practice of the painter. But let me ask you, what makes the painter’s artwork art? Is it what the audience agrees to be art? Or is it the soul-touching nature of the artwork? Perhaps it might be the rarity of the artwork, in that it is the only one of its kind to ever exist. Or maybe, it even is the skill and credibility of the painter himself, such that any canvas that he takes off the easel would be considered as art. These are all open questions that one might not have an answer for but rather the inkling of one. And it is precisely this that is the beauty of art — it is a one-way street into your soul, and the thoughts or feelings experienced can never be communicated back out from within. Therefore, what you feel is art, is, in fact, art. And what you feel is not, well, it is simply not. However, it would be a rather dismal attempt to convey my point that software design is an art if I were to say that it is so because I said so. Therefore, let me embellish my stance with some personal opinions and experiences. I feel that software design is an art because every artefact that is put out is unique, authentic, and irreproducible. It is not to say no one else can create a software artefact that serves the same function or has the same code, but rather, I mean that no one else would take the exact same approach. In fact, if I were to entirely scrap the codebase and rebuild it again from scratch, I could almost guarantee you that the final codebase will be significantly different. Because the process of designing software involves a hundred (if not a million) micro-decisions that could have disproportionally large effects on the end result, every codebase is unique. And just like in art, there can be in my perspective, good artworks and bad artworks. Good software and bad software. I might hold the view that not all codebases are worthy of being called art, even if some of them are my own. And you cannot dispute this, because to do so, you would need to draw lines and define boundaries — something that the world of art does not lend itself to. It is kind of like forcing a quantum processor to run binary code, or like forcing a continuous signal to become a discrete one — things get lossy. The beautiful thing about a software system is that once it has been written by one author, another might come along and try to refactor it, improve it, or clone it, but that software system will always be a piece of art produced by the original author. No matter who owns the codebase or what license it is distributed under, the art has already been produced, and somewhere on the planet rests its creator, pleased with his ability to create. In fact, even if the codebase never saw the light of day, every line of code written is like a stroke of a brush on a canvas. For an artwork without an audience is still art, as the creator himself has developed and grown with it, experiencing many a emotion, nurturing high hopes for it. And even if the codebase ends up as an archive on GitHub, it is still art.",
          ),
          LPTextSpan(
            lpTextComponents: [
              LPText.plainBody(
                content:
                    "It's all well and good to say that software artefacts can be creative masterpieces, but to genuinely believe that, one would need time or — as in my case — a personal experience. ",
              ),
              LPText.hyperlink(
                content: "The Hyperion Project",
                url:
                    "https://octane-site.web.app/#/project/the-hyperion-project",
              ),
              LPText.plainBody(
                content:
                    " is something that I conceived a few months back to explore the field of autonomic computing. I had high hopes and great excitement for it since the field itself is so multi-faceted and intriguing. As mentioned in my ",
              ),
              LPText.hyperlink(
                content: "previous blogule",
                url: "http://github.com",
              ),
              LPText.plainBody(content: ","),
            ],
          ),
          const LPVerseQuote(
            verses: [
              "Chillin' with the homies, tryna dodge the plight",
              "You can have all the money, but your time finite",
            ],
            reference:
                "Logic" + ', ' + "Playwright" + ' (' + "College Park" + ')',
            url: "https://youtu.be/gb1SQ2vc-5o?t=10",
          ),
        ],
        projectName: 'hyperion',
        renderWithPost: renderWithPost,
      );
}
