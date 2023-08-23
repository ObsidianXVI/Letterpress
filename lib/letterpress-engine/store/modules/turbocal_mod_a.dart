import 'package:letterpress/letterpress-engine/components/lp_components.dart';

class TurbocalModuleA extends LPModule {
  TurbocalModuleA({required bool renderWithPost})
      : super(
          title: '',
          publicationDate: DateTime.now(),
          lastUpdate: DateTime.now(),
          projectName: '',
          tags: ['flutter', 'calendar', 'flutter-package'],
          includeTableOfContents: true,
          components: <LPPostComponent>[
            LPText.header1(content: 'Overview'),
            LPTextSpan(
              lpTextComponents: [
                LPText.plainBody(
                  content:
                      'While working on Lighthouse, I made a shocking yet somewhat thrilling discovery about Flutter. On one hand, I was amazed that no one had come up with a solution to this massive, gaping void in the Flutter widget pool. In the other hand was my stylus as I started scribbling away ideas to solve this need.',
                ),
                LPText.paragraphBreak(),
                LPText.plainBody(
                  content:
                      "The issue in question is Flutter's lack of a full-fledged calendar widget. Sure, there are calendar UIs already available on ",
                ),
                LPText.hyperlink(
                  content: 'pub.dev',
                  url: 'https://pub.dev',
                ),
                LPText.plainBody(
                  content:
                      ", but look at how similar it is in quality to its competitors' equivalents:",
                ),
              ]..insertTableOfContents(0),
            ),
            const LPImage(
              url:
                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
              width: 500,
              height: 500,
            ),
            LPText.plainBody(content: 'Surely flutter can do much better?'),
            LPText.header1(content: 'Definition'),
            LPText.header2(content: 'Problem Situation'),
            LPText.plainBody(
                content:
                    "Essentially, I think what I want to create is a UI component that developers can use to implement calendar views in their apps. The UI component should be highly customisable so that it can integrate with the colour schemes and font styles of the applications they are used in."),
            LPText.header2(content: 'Design Brief'),
            LPText.plainBody(
                content: "Put into words, this is the design brief:"),
            LPText.plainBody(
                content:
                    "Design a customisable Flutter widget that provides a similar set of functionality to Google Calendar."),
            LPText.header1(content: "Imagining \"TurboCal\""),
            LPText.plainBody(
                content:
                    "Hopping over to FigJam, let's get started ideating (or, to be more precise, identifying the features from Google Calendar that we would like to implement in TurboCal)."),
            LPText.header1(content: "Designing"),
            LPText.plainBody(
                content:
                    "We are actually going to skip the UI design stage, and get straight to thinking about the implementation, because our interface will look 99% like Google Calendar."),
            LPText.paragraphBreak(),
            LPText.plainBody(
                content:
                    "We need to figure out how the various features, and especially, the interactions possible in Google Calendar, can be made possible in Flutter."),
            LPText.header2(content: "Event Formats"),
            LPTextSpan(lpTextComponents: [
              LPText.plainBody(
                  content:
                      "The first question is: which format will our event data follow? Since Lighthouse plans to be integrated with Google Calendar, and Google Calendar (as well as most other calendars) allow data to be exported in the .ical format, it seems right that we should jump onto that bandwagon as well. Thus, we will need an Event class that can contain all the fields imported from an "),
              LPText.plainBody(content: "ical"),
              LPText.plainBody(
                  content:
                      "event. While a method of reading and converting ical data to Event objects in Flutter is a must-have for TurboCal, it is not something I am going to implement as part of the TGIF Challenge. It is a paltry task of file I/O, string parsing, loops, and application of OOP principles. No time for that. We've got bigger fish to fry here. And what exactly are these bigger fish? The next section details out the main areas of consideration for implementing Google Calendar in Flutter."),
            ]),
            LPText.header2(content: "UI Implementation Plan"),
            LPText.header3(content: "Basic Display"),
            LPText.header3(content: "Drag-And-Drop Event Modification"),
            LPText.header3(content: "Event Preview"),
            LPText.header3(content: "Event Stacking"),
            LPText.header1(content: 'Developing'),
            const LPDivider(),
            const LPVerseQuote(
              verses: [
                "When the vibes is right",
                "Chillin' with the homies, tryna dodge the plight",
                "Rapper by day, but I'm a dad by night",
                "You can have all the money, but your time finite",
              ],
              reference: "Logic, Playwright (College Park)",
              url: "https://youtu.be/gb1SQ2vc-5o?t=10",
            )
          ],
          renderWithPost: renderWithPost,
        );
}
