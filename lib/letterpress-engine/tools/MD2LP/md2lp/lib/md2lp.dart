library letterpress.tools.md2lp;

import 'package:markdown/markdown.dart';

enum ParseMode { none, textspan, orderedList, unorderedList }

class MD2LP_Transpiler {
  ParseMode parseMode = ParseMode.none;
  final List<String> result = [];

  String transpile(String mdSource) {
    final ast = Document().parse(src);
    for (final Node node in ast) {
      handleNode(node);
    }
    return result.join('\n');
  }

  void handleNode(Node n) {
    if (n is Element) {
      return handleElementNode(n);
    } else {
      n as Text;
      return handleTextNode(n);
    }
  }

  void handleElementNode(Element e) {
    /* print(
        "[${e.tag}] ${e.children != null ? '(${e.children!.length})' : ''} ${e.textContent}"); */

    if (e.children == null) result.add(e.textContent);
    if (e.children!.length > 1) {
      switch (e.tag) {
        case 'p':
          parseMode = ParseMode.textspan;
          result.add("LPTextSpan(lpTextComponents: [");
        case 'ul':
          parseMode = ParseMode.unorderedList;
        case 'ol':
          parseMode = ParseMode.orderedList;
      }

      for (final Node n in e.children!) {
        handleNode(n);
      }

      switch (parseMode) {
        case ParseMode.textspan:
          result.add("],),");
        case ParseMode.unorderedList:
        case ParseMode.orderedList:
        default:
          break;
      }
      parseMode = ParseMode.none;
    } else {
      // Single-child element means child is a Text node
      switch (e.tag) {
        case 'h1':
          result.add("LPText.header1(content: \"${e.textContent}\"),");
          break;
        case 'h2':
          result.add("LPText.header2(content: \"${e.textContent}\"),");
          break;
        case 'h3':
          result.add("LPText.header3(content: \"${e.textContent}\"),");
          break;
        case 'a':
          result.add(
              "LPText.hyperlink(content: \"${e.textContent}\", url: \"${e.attributes['href']}\"),");
          break;
        case 'em':
          result.add(
              "LPText.plainBody(content: \"${e.textContent.sanitised()}\", isBold: true),");
          break;
        case 'strong':
          result.add(
              "LPText.plainBody(content: \"${e.textContent.sanitised()}\", isItalic: true),");
          break;
        case 'pre':
          break;
        case 'code':
          result.add(
              "LPText.codeStyle(content: \"${e.textContent}\", inline: ${parseMode == ParseMode.textspan}),");
          break;
        /* case 'li':
          result.add("LPText.header3(content: \"${e.textContent}\"),");
          break; */
        default:
          if (e.children![0] is Element) {
            handleElementNode(e.children![0] as Element);
          } else if (e.children![0] is Text) {
            handleTextNode(e.children![0] as Text);
          }
          break;
      }
    }
  }

  void handleTextNode(Text t) {
    result.add("LPText.plainBody(content: \"${t.textContent.sanitised()}\"),");
  }
}

extension StringUtils on String {
  String sanitised() => replaceAll('\n', '\\n').replaceAll('&quot;', '"');
}

void main() {
  print((MD2LP_Transpiler()..transpile(src)).result.join('\n'));
  //
}

final String src = """Complex Calendar Widget in Flutter (Turbocal)

# Overview
This is *embolded*, and this is **italicised**, but ~~none~~ are normal.
<TOC>
While working on Lighthouse, I made a shocking yet somewhat thrilling discovery about Flutter. On one hand, I was amazed that no one had come up with a solution to this massive, gaping void in the Flutter widget pool. In the other hand was my stylus as I started scribbling away ideas to solve this need.

The `issue` in question is Flutter's lack of a full-fledged calendar widget. Sure, there are calendar UIs already available on [pub.dev](https://pub.dev), but look at how similar it is in quality to its competitors' equivalents:
@img {
    url: https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg
    width: 500
    height: 500
}

Surely flutter can do much better?

# Definition
## `Problem` Situation
Essentially, I think what I want to create is a UI component that developers can use to implement calendar views in their apps. The UI component should be highly customisable so that it can integrate with the colour schemes and font styles of the applications they are used in.
Like:
1. Itme one
2. item 2
3. item 3

but not like:

- ererr
- bufeubfbf
- yeee

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

[foolink](https://github.com/ObsidianXVI/TurboCal/commit/30eadaa3383bff75e8938749f254f9adaf56f66e)

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
