Powerful Code Editor in Flutter (Affogato) — Part I

# Overview
<TOC>
Preamble

# Definition
## Problem Situation
## Design Brief

# Imagining "Affogato"
- feature list (inspired by Monaco editor)
- looking at xcode interface, interactions
- knowing how VScode looks like

# Designing
- trying to do proto in Figma, too time-consuming => create wireframe

# Developing
## Editor Part I: Experimenting, Simple Features
[Commit](https://github.com/ObsidianXVI/Affogato-Editor/tree/b2141c7b3815e137c3bbb5090edfad6676b9613e)
- developing the AffogatoWidget (++ describe)
    - trying to use TextField based on existing research
        - https://github.com/BertrandBev/code_field/blob/master/lib/src/code_field/code_field.dart
        - https://github.com/ThomasGysemans/code_editor
    - TextField didn't work
        - main problem: cannot style the text for syntax highlighting
    - decided to do ground-up implementation

## Editor Part II: Char Cell Editor Model
[Commit](https://github.com/ObsidianXVI/Affogato-Editor/tree/0e6aff6be676963aea4a317a9b626f67c0f52cbc)
- describe the model
    - `Editor` > `List<EditorLines>` > `List<CharCellComponent>`
    - uses event-driven model to:
        - remove cursors from other `CharCellComponent`s when cursor is moved
        - add cursor to active `CharCellComponent`
        - can get VSCode-like configs: `events.cursor.onFocusChange`
        - but expensive, not feasible in long term
    - spawn cursor when taps outside of `CharCellComponent`

## Parsing Model Part I: First Ideas
[Commit](https://github.com/ObsidianXVI/Affogato-Editor/tree/b541d190beebd37a05c0a347a1bcef28d29bb210)
- describe the model
    - `AffogatoLanguageTheme`
    - `AffogatoLanguageBundle`
        - `AffogatoTokeniser` produces `AffogatoToken`s
        - `AffogatoParser` produces `AffogatoParseObject`s
        - `AffogatoParseObject`
            - `AffogatoScope` (++explain how it is planned to be used in reparsing)

## Parsing Model Part II: Notion of Documents
[Commit](https://github.com/ObsidianXVI/Affogato-Editor/tree/f1a1fba57914ca7f12398f1e6ce3a32c3e315860)
- introduce notion of `AffogatoDocument`
- binding a document to an editor, to be parsed using a language bundle
- need `AffogatoEngine` to manage all these

## Parsing Model Part III: DocumentMap
[Commit](https://github.com/ObsidianXVI/Affogato-Editor/tree/9925b502a9e24336e2c1235ab10fa92c3882e3b0)
- idea from Letterpress MD2LP parser
- discuss model
    - SourceMap, Cursor, CursorLocation
    - how the model is expected to fit in with AffogatoTokeniser, AffogatoDocument, reparsing, editor

## Editor Part III: Non-Event-Driven
[Commit](https://github.com/ObsidianXVI/Affogato-Editor/tree/10b18464d664270b67670f33932cd02ab8c3e09f)
- instead of creating a cursor whenever focus is changed, a single cursor is used, and the entire editor is redrawn when focus is changed
- the cursor keeps track of old and new `CharCellComponents`, calling setState for only the two cells affected
- realised `Editor.setState` was being called frequently, `Editor`'s build method is expensive, so moved the `List.generate` widgets out of the `build` method
- instead of rebuilding `CharCellComponent`s and `EditorLine`s whenever the document is changed, actions that modify the document will themselves update the document, refresh the cells and lines, then call `Editor.setState`
- still need `EditorLine` to detect outside taps

## Parsing Model Part IV: Roadblock
[Commit](https://github.com/ObsidianXVI/Affogato-Editor/tree/2b7da7601cca5d1f153fc9333ad0e8c822cb15a7)
- updates to parsing model to see how it would fit in
- realised that everything works well, except for the people creating the language bundles
- might need tools and a more simplified model

@div

@versequote {
    artist: Bad Meets Evil
    song: Fast Lane
    album: Hell: The Sequel (Deluxe)
    hyperlink:
    verses: [
I'm livin' life in the fast lane
Movin' at the speed of life and I can't slow down
Only got a gallon in the gas tank
But I'm almost at the finish line, so I can't stop now
I don't really know where I'm headed, just enjoyin' the ride
Just gon' roll 'til I drop and ride 'til I die
    ]
}