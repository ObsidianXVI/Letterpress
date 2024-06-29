part of letterpress.store;

class Enter_Autonomic_Computing extends LPModule {
  Enter_Autonomic_Computing({required bool renderWithPost})
      : super(
          title: "Enter Autonomic Computing",
          coverImgName: 'Serendipity',
          lastUpdate: DateTime(2023, 10, 29),
          publicationDate: DateTime(2023, 10, 29),
          tags: [],
          includeTableOfContents: false,
          components: [
            LPTextSpan(lpTextComponents: [
              LPText.plainBody(
                  content:
                      "It's February 2023. I've had only one mega project so far (my first ever project since I started coding), and that was "),
              LPText.hyperlink(
                content: 'Lighthouse',
                route:
                    '${LPRoutes.lp_blogules}/${lh_a_formal_intro_to_lh.title.urlSafeSlug}',
              ),
              LPText.plainBody(
                  content:
                      ". If you haven't heard about it yet, it's a personal productivity system that aims to revolutionise how you organise your life."),
            ]),
            LPText.plainBody(
                content:
                    "But now, development on Lighthouse had progressed remarkably well, everything was smooth sailing — and by that, I mean that even though bugs (or even crises) came up, I was able to overcome them — since I was just designing frames and building them out in Flutter. Then of course, my mind started thinking of new projects again. Most of the time, project ideas come to me first, and then I evaluate whether they solve an actual need or not to decide if the ideas are worth pursuing. But that would not work this time, since I wanted to do something big, even bigger than Lighthouse. I wanted to work on a long-term project that would be ongoing for years, and with a lasting impact on the wider community."),
            LPText.plainBody(
                content:
                    "Since machine learning was (and currently still is, thanks to ChatGPT) a hot topic, I figured that would be a possible road to head down. However, I didn't feel comfortable just jumping onto the AI bandwagon, so I wanted to explore other options. Quantum computing had an enigmatic allure, so I took a look at a few samples by Microsoft, and watched a few tutorials to try and understand quantum computing. And that's how I knew I never wanted to go down that rabbit hole ever again."),
            LPText.plainBody(
                content:
                    "As a last resort, I pulled up the Gartner Hype Cycle for Emerging Technologies and after poking around for a while, came across the words “autonomic computing” somewhere. My attention was piqued because I had always wondered whether there were systems in existence that could run and manage themselves without human intervention. Soon enough, I spiralled:"),
            LPImage.asset(
              assetPath:
                  '/images/hyperion/enter_autonomic_computing/history_1.png',
              width: 500,
              height: 575,
            ),
            LPText.plainBody(
                content:
                    "As fascinated as I was with the whole topic and its novelty, I looked into the scope for research and complexity overall, and I was pleased to find that it was a relatively new concept introduced in 2001, with a small collection of resources to learn from. Complexity-wise, the subject seemed to lean more towards software development than computer science, which was good because I knew there was no way I could compete with researchers holding PhDs and majors in computer science. Instead, in software development, I could try out different architectures and conduct experiments and put my coding skills to practice. Of course, there would still be theoretical aspects involved, but at least I would not have to grapple with the sheer amounts of background knowledge needed to approach this topic computer-scientifically. Anyway, after about a week, I was sold:"),
            LPImage.asset(
              assetPath:
                  '/images/hyperion/enter_autonomic_computing/history_2.png',
              width: 500,
              height: 250,
            ),
            LPText.plainBody(
                content:
                    "I also finally understood the importance of Open Science:"),
            LPImage.asset(
              assetPath:
                  '/images/hyperion/enter_autonomic_computing/history_3.png',
              width: 500,
              height: 441,
            ),
            LPText.plainBody(
                content:
                    "And, that my friends, is how I was introduced to the world of autonomic computing. Little did I know, another highly coincidental event in my life would seal the fate of me researching on this area…"),
          ],
          projectName: 'hyperion',
          renderWithPost: renderWithPost,
        );
}
