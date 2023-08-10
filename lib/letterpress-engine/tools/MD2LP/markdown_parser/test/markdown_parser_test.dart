import 'package:markdown_parser/markdown_parser.dart';
import 'package:markdown_parser/src/markdown_parser.dart';
import 'package:test/test.dart';

void main() {
  final GlobalParser globalParser = GlobalParser(
    parserConfigs: ParserConfigs(
      lineTriggeredParsers: [
        const VerseQuote_Parser(),
      ],
      charTriggeredParsers: [],
      includeCoreTokens: true,
    ),
  );
  final List<Token> tokens = globalParser.parseString(src.trim());
  for (Token t in tokens) {
    print(t);
  }
/*   final SourceMap original = SourceMap(source: src);
  print(original.charAt(original.advanceCursor(3))); */
}

final String src = """
Complex Calendar Widget in Flutter (Turbocal)

# Overview
<TOC>
While working on Lighthouse, I made a shocking yet somewhat thrilling discovery about Flutter. On one hand, I was amazed that no one had come up with a solution to this massive, gaping void in the Flutter widget pool. In the other hand was my stylus as I started scribbling away ideas to solve this need.

The issue in question is Flutter's lack of a full-fledged calendar widget. Sure, there are calendar UIs already available on [pub.dev](https://pub.dev), but look at how similar it is in quality to its competitors' equivalents:
@img {
    url: https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg
    width: 500
    height: 500
}

Surely flutter can do much better?

# Definition
## Problem Situation
Essentially, I think what I want to create is a UI component that developers can use to implement calendar views in their apps. The UI component should be highly customisable so that it can integrate with the colour schemes and font styles of the applications they are used in.

## Design Brief
Put into words, this is the design brief:
```
Design a customisable Flutter widget that provides a similar set of functionality to Google Calendar.
```
Hopping over to FigJam, let's get started ideating (or, to be more precise, identifying the features from Google Calendar that we would like to implement in TurboCal).

# Imagining "Turbocal"
Hopping over to FigJam, let's get started ideating (or, to be more precise, identifying the features from Google Calendar that we would like to implement in TurboCal).


# Designing
We are actually going to skip the UI design stage, and get straight to thinking about the implementation, because our interface will look 99% like Google Calendar.

## Event Formats
We need to figure out how the various features, and especially, the interactions possible in Google Calendar, can be made possible in Flutter.

The first question is: which format will our event data follow? Since Lighthouse plans to be integrated with Google Calendar, and Google Calendar (as well as most other calendars) allow data to be exported in the .ical format, it seems right that we should jump onto that bandwagon as well. Thus, we will need an Event class that can contain all the fields imported from an `ical` event. While a method of reading and converting `ical` data to `Event` objects in Dart is a must-have for TurboCal, it is not something I am going to implement as part of the TGIF Challenge. It is a paltry task of file I/O, string parsing, loops, and application of OOP principles. No time for that. We've got bigger fish to fry here.The next section details out these bigger fish we're about to fry when implementing Google Calendar in Flutter.

## UI Implementation Plan
### Basic Display

### Drag-And-Drop Event Modification
### Event Preview
### Event Stacking

# Developing
## TCInstance
[https://github.com/ObsidianXVI/TurboCal/commit/30eadaa3383bff75e8938749f254f9adaf56f66e](https://github.com/ObsidianXVI/TurboCal/commit/30eadaa3383bff75e8938749f254f9adaf56f66e)

First of all, I got the a basic instance of Turbocal up and running — a bare-bones UI with columns (`TCColumn`s) and a panel at the top.

The interface is accompanied by a `TCConfigs` object that contains all the configuration information, such as the view type (week/day/month), timescale zoom (the height of each hour block), colours, dimensions, and lastly, the information to display.

## LinkedScrollable
[https://github.com/ObsidianXVI/TurboCal/commit/9b3148bc84ad105278827894ca15ec5205e6be35](https://github.com/ObsidianXVI/TurboCal/commit/9b3148bc84ad105278827894ca15ec5205e6be35)

In the next commit, I created a `LinkedScrollable` that allows all the columns to scroll in sync, **when needed**. Though we want our columns to scroll together most of the time, I was thinking that in future features of Turbcal, we might want to detach the scrolling of a certain column with the rest of the columns, so a `LinkedScrollableControlPoint` would serve to control all the scrolling behaviours of the columns. The downside of this approach is that there is a slight delay of 10 microseconds (it sounds small, but it's visible when interacting with the calendar) for all the other columns to catch up with the new scroll positions.

## scopeStartDate
[https://github.com/ObsidianXVI/TurboCal/commit/0e427dc39d167c8e276ed393f5d7e13c4ddb4085]()

The `TCInstance` automatically scopes to the current week, and the `TCColumn`s also display the respective day names and dates.

## The Event Canvas
[https://github.com/ObsidianXVI/TurboCal/commit/75443e44f1dd17452ca95567a52f35c2739e63f4](https://github.com/ObsidianXVI/TurboCal/commit/75443e44f1dd17452ca95567a52f35c2739e63f4)

It's about time we got to the actually complex part of Turbocal. I implemented a rudimentary event canvas that strictly does not allow for event stacking.

## The Meltdown

[https://github.com/ObsidianXVI/TurboCal/commit/60e4e70d2edf88fdc30cba87ef5badf16cf233c4](https://github.com/ObsidianXVI/TurboCal/commit/60e4e70d2edf88fdc30cba87ef5badf16cf233c4)

There's coding, and then there's having-a-mental-breakdown-trying-to-get-it-to-work coding. I had my meltdown because of some dumb bug that made all the columns stack on top of each other, and I couldn't fix it no matter what I tried. After trying for about a week, I took a break from Turbocal, and eventually got around to doing it a month later. So when I say "annoying" in the commit message, I *mean* annoying.

## Event Stacking

[https://github.com/ObsidianXVI/TurboCal/commit/5565ef30d033d7d001b8d2cf088941933200c2a5](https://github.com/ObsidianXVI/TurboCal/commit/5565ef30d033d7d001b8d2cf088941933200c2a5)

The event canvas gets a massive upgrade which now allows multiple overlapping events to be displayed in one column. The `TCColumn` is now based on a `Stack` widget instead of a `Column`. It's still going to be called a `TCColumn` and not `TCStack` though, because if I did that and the code started breaking, I would never forgive myself.

## View Autoscroll
[https://github.com/ObsidianXVI/TurboCal/commit/a52fd48357c96dd39fb7a9af1895bedd9c5f5512](https://github.com/ObsidianXVI/TurboCal/commit/a52fd48357c96dd39fb7a9af1895bedd9c5f5512)

A more light-hearted feature that makes event cards interactive on hover, and autoscrolls to the current time (or a preset time if configured).

@div

@versequote {
    artist: Logic
    song: Playwright
    album: College Park
    hyperlink: https://youtu.be/gb1SQ2vc-5o?t=10
    verses: [
        When the vibes is right
        Chillin' with the homies, tryna dodge the plight
        Rapper by day, but I'm a dad by night
        You can have all the money, but your time finite
    ]
}

""";
