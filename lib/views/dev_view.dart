part of letterpress.views;

class DevView extends StatelessWidget {
  const DevView({super.key});

  @override
  Widget build(BuildContext context) {
    return ViewScaffold(
      child: Center(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          color: LPColor.inkBlue_700,
          child: LPRenderer(article: TestModule(renderWithPost: true)),
        ),
      ),
    );
  }
}

/***
 * 
 * 
 * 
 * 
 * 
 * 
 */
class TestModule extends LPModule {
  TestModule({required bool renderWithPost})
      : super(
          title: "Test Module",
          coverImgName: 'Caffiend_Crawlin_Out_The_Same_Ditch',
          lastUpdate: DateTime(2023, 10, 29),
          publicationDate: DateTime(2023, 9, 4),
          tags: [],
          includeTableOfContents: false,
          components: [
            LPText.plainBody(
                content:
                    "Lighthouse is a project I started in the June of 2022, 3 months after I first started coding. Even though Lighthouse was my first coding project (I had never completed even a single mini-project while learning to code), I wanted to go big."),
            LPText.plainBody(
                content:
                    "I asked myself, “What would be a useful application to develop? What is something that people, including me, would actually use?”. At the time of thinking, I was really into productivity and the like. I was playing around with many different types of software, from project management tools like Jira or Asana, to calendars like the one by Apple or Google. Learning about integration and IoT was another big thing that I had going on at the time, and that constitutes the other half of the driving force behind Lighthouse."),
            LPTextSpan(lpTextComponents: [
              LPText.plainBody(content: "But we need the "),
              LPText.codeStyle(inline: true, content: "abstract"),
              LPText.plainBody(content: " keyword to enable it."),
            ]),
            const LPCallout(
              title: 'NOTE',
              content:
                  'Do not use Flutter build web on platforms deployed after 10 jan',
              calloutType: CalloutType.note,
            ),
            const LPCallout(
              title: 'WARNING',
              content:
                  'Do not use Flutter build web on platforms deployed after 10 jan',
              calloutType: CalloutType.moderate,
            ),
            const LPCallout(
              title: 'DEPRECATED',
              content:
                  'Do not use Flutter build web on platforms deployed after 10 jan',
              calloutType: CalloutType.critical,
            ),
            const LPPullQuote(
              content: "It's not a bug, it's a feature.",
              attribution: 'Every programmer ever',
              ref: 'https://github.com',
            ),
            LPText.plainBody(
                content:
                    "Having just discovered all the amazing things possible in the world of 0s and 1s, I was obviously more interested in learning what it could do for me. So I got into scripting. Nope, not Python as you would think, but instead, with iOS Shortcuts. For those who don't know, Shortcuts is an iOS application where you can create programs and automations to execute commands on your iPhone easily. I was trying to use Shortcuts to integrate the different tools I used, and went so far as to try out different URL schemes and X-callbacks. What I found to be sorely lacking was integration and interoperability between the different tools."),
            LPText.plainBody(
                content:
                    "As such, I wanted Lighthouse to be the ultimate productivity tool — one that could help you get your entire act together, not just your personal or professional acts; one that integrates with various tools that you already use; one that was customisable and extensible; one that actually worked with you instead of just increasing administrative overhead."),
            LPCodeBlock(
              content: """abstract class LPQuote extends LPPostComponent {
  const LPQuote({
    super.leftSideNotes,
    super.rightSideNotes,
    super.key,
  });
}""",
            ),
            LPText.plainBody(
                content:
                    "Needless to say, all of this was a very ambitious undertaking, but what better did I know? All I had at the time was a basic understanding of Python and a burning desire to build Lighthouse. They say a journey of a thousand miles begins with a single step, and I dived headfirst into this bitch."),
          ],
          projectName: 'lighthouse',
          renderWithPost: renderWithPost,
        );
}

class TestModule2 extends LPModule {
  TestModule2()
      : super(
          title: "Test Module",
          coverImgName: 'Caffiend_Crawlin_Out_The_Same_Ditch',
          lastUpdate: DateTime(2023, 10, 29),
          publicationDate: DateTime(2023, 9, 4),
          tags: [],
          projectName: 'X',
          includeTableOfContents: false,
          renderWithPost: true,
          components: [
            LPText.plainBody(
                content: "Complex Calendar Widget in Flutter (Turbocal)"),
            LPText.header1(content: "Overview"),
            LPTextSpan(
              lpTextComponents: [
                LPText.plainBody(content: "This is "),
                LPText.plainBody(content: "embolded", isBold: true),
                LPText.plainBody(content: ", and this is "),
                LPText.plainBody(content: "italicised", isItalic: true),
                LPText.plainBody(
                    content:
                        ", but ~~none~~ are normal.\n<TOC>\nWhile working on Lighthouse, I made a shocking yet somewhat thrilling discovery about Flutter. On one hand, I was amazed that no one had come up with a solution to this massive, gaping void in the Flutter widget pool. In the other hand was my stylus as I started scribbling away ideas to solve this need."),
              ],
            ),
            LPTextSpan(
              lpTextComponents: [
                LPText.plainBody(content: "The "),
                LPText.codeStyle(content: "issue", inline: true),
                LPText.plainBody(
                    content:
                        " in question is Flutter's lack of a full-fledged calendar widget. Sure, there are calendar UIs already available on "),
                LPText.hyperlink(content: "pub.dev", url: "https://pub.dev"),
                LPText.plainBody(
                    content:
                        ", but look at how similar it is in quality to its competitors' equivalents:\n@img {\n    url: https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg\n    width: 500\n    height: 500\n}"),
              ],
            ),
            LPText.plainBody(content: "Surely flutter can do much better?"),
            LPText.header1(content: "Definition"),
            LPText.codeStyle(content: "Problem", inline: false),
            LPText.plainBody(content: " Situation"),
            LPText.plainBody(
                content:
                    "Essentially, I think what I want to create is a UI component that developers can use to implement calendar views in their apps. The UI component should be highly customisable so that it can integrate with the colour schemes and font styles of the applications they are used in.\nLike:"),
            LPText.plainBody(content: "Itme one"),
            LPText.plainBody(content: "item 2"),
            LPText.plainBody(content: "item 3"),
            LPText.plainBody(content: "but not like:"),
            LPText.plainBody(content: "ererr"),
            LPText.plainBody(content: "bufeubfbf"),
            LPText.plainBody(content: "yeee"),
            LPText.header2(content: "Design Brief"),
            LPText.plainBody(
                content: "Put into words, this is the design brief:"),
            LPText.plainBody(
                content:
                    "Hopping over to FigJam, let's get started ideating (or, to be more precise, identifying the features from Google Calendar that we would like to implement in TurboCal)."),
            LPText.header1(content: "Imagining &quot;Turbocal&quot;"),
            LPText.plainBody(
                content:
                    "Hopping over to FigJam, let's get started ideating (or, to be more precise, identifying the features from Google Calendar that we would like to implement in TurboCal)."),
            LPText.header1(content: "Designing"),
            LPText.plainBody(
                content:
                    "We are actually going to skip the UI design stage, and get straight to thinking about the implementation, because our interface will look 99% like Google Calendar."),
            LPText.header2(content: "Event Formats"),
            LPText.plainBody(
                content:
                    "We need to figure out how the various features, and especially, the interactions possible in Google Calendar, can be made possible in Flutter."),
            LPTextSpan(
              lpTextComponents: [
                LPText.plainBody(
                    content:
                        "The first question is: which format will our event data follow? Since Lighthouse plans to be integrated with Google Calendar, and Google Calendar (as well as most other calendars) allow data to be exported in the .ical format, it seems right that we should jump onto that bandwagon as well. Thus, we will need an Event class that can contain all the fields imported from an "),
                LPText.codeStyle(content: "ical", inline: true),
                LPText.plainBody(
                    content:
                        " event. While a method of reading and converting "),
                LPText.codeStyle(content: "ical", inline: true),
                LPText.plainBody(content: " data to "),
                LPText.codeStyle(content: "Event", inline: true),
                LPText.plainBody(
                    content:
                        " objects in Dart is a must-have for TurboCal, it is not something I am going to implement as part of the TGIF Challenge. It is a paltry task of file I/O, string parsing, loops, and application of OOP principles. No time for that. We've got bigger fish to fry here.The next section details out these bigger fish we're about to fry when implementing Google Calendar in Flutter."),
              ],
            ),
            LPText.header2(content: "UI Implementation Plan"),
            LPText.header3(content: "Basic Display"),
            LPText.header3(content: "Drag-And-Drop Event Modification"),
            LPText.header3(content: "Event Preview"),
            LPText.header3(content: "Event Stacking"),
            LPText.header1(content: "Developing"),
            LPText.header2(content: "TCInstance"),
            LPText.hyperlink(
                content: "foolink",
                url:
                    "https://github.com/ObsidianXVI/TurboCal/commit/30eadaa3383bff75e8938749f254f9adaf56f66e"),
            LPText.plainBody(content: "@div"),
            LPText.plainBody(
                content:
                    "@versequote {\n    artist: Logic\n    song: Playwright\n    album: College Park\n    hyperlink: https://youtu.be/gb1SQ2vc-5o?t=10\n    verses: [\n        When the vibes is right\n        Chillin' with the homies, tryna dodge the plight\n        Rapper by day, but I'm a dad by night\n        You can have all the money, but your time finite\n    ]\n}"),
          ],
        );
}
