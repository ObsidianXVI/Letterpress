part of letterpress.store;

class Homage_27_11_23 extends LPModule {
  Homage_27_11_23({required bool renderWithPost})
      : super(
          title: "27/11/23: Homage",
          lastUpdate: DateTime(2023, 11, 27),
          publicationDate: DateTime(2023, 11, 27),
          tags: [],
          includeTableOfContents: false,
          components: [
            LPText.plainBody(
                content:
                    "I was just sitting on a toilet seat and 💩 was going down when out of nowhere, I got hit with a mind-blowing epiphany about my journey so far."),
            LPText.plainBody(
                content:
                    "What I realised was that most, if not all, of my coding projects were all very closely tied to the Dart language and Flutter framework. From contributions to the Flutter community such as through Project Redline, Orca, and Affogato Editor, to dependency on Flutter as a powerful framework for The Lighthouse Project and my personal site, the perfect fit of Flutter/Dart for all of my coding needs was an amazing coincidence."),
            LPText.plainBody(
                content:
                    "However, this discovery would not have been possible if I had just given up on The Lighthouse Project, which was my first serious undertaking. Initially, I had planned to use EditorX to build the website, but since it lacked fine-grain control over design, I had to look for alternative platforms. Since I was only familiar with Python and NodeJS at the time, it was a very unnerving predicament to be in. But I did not give up. Many YouTube videos and documentation readings later, I had finally settled upon Flutter as the right tool to move forward with. While I was more familiar with the runner-ups — NativeScript and AngularJS — since I was fluent in NodeJS, Flutter seemed to be better for me in the long term."),
            LPText.plainBody(
                content:
                    "If I had never taken that decision, if I had picked some other platform or even just given up entirely, I may not have been able to achieve what I have today. With mastery of a statically-typed language like Dart, I find myself confidently exploring various ideas and undertaking projects to experiment with different concepts. The extremely pivotal nature of that one decision, and of not giving up, is something that cannot be done justice by mere words on a line. "),
            const LPDivider(),
            const LPVerseQuote(
              verses: [
                "I just thank for the life, for the days, for the hours",
                "And another life breathin'",
                "I did it all 'cause it feel good",
                "You'd leave it all if it feel bad",
                "Better live your life",
                "We were running out of time",
              ],
              reference:
                  "Kendrick Lamar | SZA, All The Stars (Black Panther the Album)",
              url: "https://youtu.be/JQbjS0_ZfJ0?t=160",
            )
          ],
          projectName: '',
          renderWithPost: renderWithPost,
        );
}
