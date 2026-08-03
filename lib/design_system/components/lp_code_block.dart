part of letterpress.ds;

/// Syntax highlighting tuned to the Letterpress palette.
///
/// `re_highlight` ships dozens of ready-made themes, but they are all built for
/// other people's colour schemes and would drop unrelated hues into the middle
/// of an article. These scopes map highlight.js token classes onto the site's
/// own inks instead, so code reads as part of the page rather than as a
/// pasted-in screenshot.
class LPCodeTheme {
  const LPCodeTheme._();

  static const TextStyle _keyword = TextStyle(color: LPColor.chaseRed_500);
  static const TextStyle _literal = TextStyle(color: LPColor.gripperBlue_400);
  static const TextStyle _string = TextStyle(color: LPColor.rollerBlue_500);

  static Map<String, TextStyle> get scopes => <String, TextStyle>{
        'keyword': _keyword,
        'built_in': _keyword,
        'type': _literal,
        'literal': _literal,
        'number': _literal,
        'operator': _keyword,
        'punctuation': TextStyle(
          color: LPColor.platenWhite_500.withOpacity(0.5),
        ),
        'property': _literal,
        'regexp': _string,
        'string': _string,
        'subst': _string,
        'symbol': _literal,
        'class': _literal,
        'function': TextStyle(color: LPColor.gripperBlue_500),
        'title': TextStyle(color: LPColor.gripperBlue_500),
        'params': TextStyle(
          color: LPColor.platenWhite_500.withOpacity(0.85),
        ),
        'comment': TextStyle(
          color: LPColor.platenWhite_500.withOpacity(0.35),
          fontStyle: FontStyle.italic,
        ),
        'doctag': TextStyle(
          color: LPColor.platenWhite_500.withOpacity(0.45),
          fontStyle: FontStyle.italic,
        ),
        'meta': TextStyle(color: LPColor.rollerBlue_500.withOpacity(0.8)),
        'meta-keyword': _keyword,
        'meta-string': _string,
        'attr': _literal,
        'attribute': _literal,
        'variable': TextStyle(color: LPColor.platenWhite_500),
        'name': TextStyle(color: LPColor.gripperBlue_500),
        'tag': _keyword,
        'selector-tag': _keyword,
        'selector-id': _literal,
        'selector-class': _literal,
        'section': TextStyle(color: LPColor.gripperBlue_500),
        'bullet': _keyword,
        'quote': TextStyle(
          color: LPColor.platenWhite_500.withOpacity(0.6),
          fontStyle: FontStyle.italic,
        ),
        'emphasis': TextStyle(fontStyle: FontStyle.italic),
        'strong': TextStyle(fontWeight: FontWeight.w600),
        'addition': TextStyle(color: LPColor.gripperBlue_400),
        'deletion': TextStyle(color: LPColor.chaseRed_500),
      };
}

/// Shared highlighter.
///
/// Registering the full language set would pull every grammar `re_highlight`
/// ships into the web bundle. Articles here are about a handful of languages,
/// so only those are registered; anything else falls through to unstyled text,
/// which still gets line numbers and selection.
class LPHighlighter {
  const LPHighlighter._();

  static Highlight? _instance;

  /// Grammars registered for article code blocks, keyed by the `lang` string
  /// an article passes to [LPCodeBlock].
  static final Map<String, Mode> languages = <String, Mode>{
    'dart': langDart,
    'bash': langBash,
    'shell': langBash,
    'sh': langBash,
    'go': langGo,
    'python': langPython,
    'javascript': langJavascript,
    'js': langJavascript,
    'typescript': langTypescript,
    'ts': langTypescript,
    'json': langJson,
    'yaml': langYaml,
    'yml': langYaml,
    'sql': langSql,
    'swift': langSwift,
    'kotlin': langKotlin,
    'java': langJava,
    'rust': langRust,
    'c': langC,
    'cpp': langCpp,
    'xml': langXml,
    'html': langXml,
    'css': langCss,
    'markdown': langMarkdown,
    'md': langMarkdown,
  };

  static Highlight get instance {
    final Highlight highlight = _instance ??= Highlight()
      ..registerLanguages(languages);
    return highlight;
  }

  static bool supports(String lang) =>
      languages.containsKey(lang.toLowerCase());

  /// Highlights [source], falling back to a single unstyled span when the
  /// language is unknown or its grammar rejects the input.
  static TextSpan highlight({
    required String source,
    required String lang,
    required TextStyle baseStyle,
  }) {
    final String normalised = lang.toLowerCase();
    if (!supports(normalised)) {
      return TextSpan(text: source, style: baseStyle);
    }

    try {
      final HighlightResult result = instance.highlight(
        code: source,
        language: normalised,
        ignoreIllegals: true,
      );
      final TextSpanRenderer renderer =
          TextSpanRenderer(baseStyle, LPCodeTheme.scopes);
      result.render(renderer);
      return renderer.span ?? TextSpan(text: source, style: baseStyle);
    } catch (_) {
      // A grammar that throws should cost the reader a bit of colour, not the
      // whole code block.
      return TextSpan(text: source, style: baseStyle);
    }
  }
}

/// A block of source code, with line numbers, highlighting and a copy action.
///
/// Article components are [LPPostComponent]s, which are stateless, so the
/// interactive parts (copy feedback, horizontal scroll position) live in the
/// [_LPCodeBlockView] this builds rather than in the component itself.
class LPCodeBlock extends LPPostComponent {
  final String lang;
  final String content;

  /// Where the snippet came from — a file path, a repo, a citation.
  final String? provenance;

  /// Whether to show the line-number gutter.
  final bool showLineNumbers;

  const LPCodeBlock({
    required this.content,
    this.lang = 'plain',
    this.provenance,
    this.showLineNumbers = true,
    super.leftSideNotes,
    super.rightSideNotes,
    super.key,
  });

  @override
  Widget build(BuildContext context) => _LPCodeBlockView(
        content: content,
        lang: lang,
        provenance: provenance,
        showLineNumbers: showLineNumbers,
      );
}

class _LPCodeBlockView extends StatefulWidget {
  final String lang;
  final String content;
  final String? provenance;
  final bool showLineNumbers;

  const _LPCodeBlockView({
    required this.content,
    required this.lang,
    required this.provenance,
    required this.showLineNumbers,
  });

  @override
  State<_LPCodeBlockView> createState() => _LPCodeBlockViewState();
}

class _LPCodeBlockViewState extends State<_LPCodeBlockView> {
  final ScrollController horizontalController = ScrollController();
  bool justCopied = false;

  @override
  void dispose() {
    horizontalController.dispose();
    super.dispose();
  }

  /// Trailing blank lines are almost always an artefact of how the snippet was
  /// written into a Dart string literal, not part of the code.
  List<String> get lines {
    final List<String> raw = widget.content.split('\n');
    while (raw.isNotEmpty && raw.last.trim().isEmpty) {
      raw.removeLast();
    }
    return raw.isEmpty ? [''] : raw;
  }

  Future<void> copy() async {
    try {
      await Clipboard.setData(ClipboardData(text: widget.content));
    } catch (_) {
      // Browsers can refuse clipboard access outright. Claiming success would
      // be worse than staying quiet, so the label simply does not change.
      return;
    }
    if (!mounted) return;
    setState(() => justCopied = true);
    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    setState(() => justCopied = false);
  }

  @override
  Widget build(BuildContext context) {
    final LPViewportData vp = LPViewport.of(context);

    final TextStyle baseStyle = code.apply(
      TextStyle(color: LPColor.platenWhite_500.withOpacity(0.85)),
    );
    final List<String> codeLines = lines;
    final int gutterDigits = codeLines.length.toString().length;

    final TextStyle gutterStyle = baseStyle.copyWith(
      color: LPColor.platenWhite_500.withOpacity(0.28),
    );

    return Container(
      decoration: BoxDecoration(
        color: LPColor.inkBlue_500.withOpacity(0.5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: LPColor.rollerBlue_500.withOpacity(0.35),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          _header(vp),
          // Horizontal scrolling belongs to the code, not the gutter: line
          // numbers should stay put while a long line scrolls past them.
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (widget.showLineNumbers)
                _gutter(codeLines.length, gutterDigits, gutterStyle),
              Expanded(
                child: Scrollbar(
                  controller: horizontalController,
                  thumbVisibility: false,
                  child: SingleChildScrollView(
                    controller: horizontalController,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.fromLTRB(
                      widget.showLineNumbers ? 12 : 14,
                      12,
                      14,
                      14,
                    ),
                    child: Text.rich(
                      LPHighlighter.highlight(
                        source: codeLines.join('\n'),
                        lang: widget.lang,
                        baseStyle: baseStyle,
                      ),
                      softWrap: false,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _header(LPViewportData vp) {
    final bool hasLangLabel =
        widget.lang.isNotEmpty && widget.lang.toLowerCase() != 'plain';

    return Container(
      padding: const EdgeInsets.fromLTRB(14, 8, 8, 8),
      decoration: BoxDecoration(
        color: LPColor.inkBlue_700.withOpacity(0.6),
        border: Border(
          bottom: BorderSide(color: LPColor.rollerBlue_500.withOpacity(0.25)),
        ),
      ),
      child: Row(
        children: [
          if (hasLangLabel)
            Text(
              widget.lang.toLowerCase(),
              style: code.apply(
                TextStyle(
                  color: LPColor.rollerBlue_500.withOpacity(0.9),
                  fontSize: 12,
                  letterSpacing: 1.2,
                ),
              ),
            ),
          if (hasLangLabel && widget.provenance != null)
            Text(
              '  ·  ',
              style: code.apply(
                TextStyle(
                  color: LPColor.platenWhite_500.withOpacity(0.3),
                  fontSize: 12,
                ),
              ),
            ),
          if (widget.provenance != null)
            Flexible(
              child: Text(
                widget.provenance!,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: code.apply(
                  TextStyle(
                    color: LPColor.platenWhite_500.withOpacity(0.45),
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          const Spacer(),
          _CopyButton(justCopied: justCopied, onPressed: copy),
        ],
      ),
    );
  }

  Widget _gutter(int lineCount, int digits, TextStyle style) {
    return Container(
      padding: const EdgeInsets.fromLTRB(14, 12, 10, 14),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(color: LPColor.rollerBlue_500.withOpacity(0.2)),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: List<Widget>.generate(
          lineCount,
          (int i) => Text(
            (i + 1).toString().padLeft(digits),
            style: style,
          ),
        ),
      ),
    );
  }
}

class _CopyButton extends StatelessWidget {
  final bool justCopied;
  final VoidCallback onPressed;

  const _CopyButton({required this.justCopied, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: LPColor.rollerBlue_500.withOpacity(justCopied ? 0.2 : 0.08),
            borderRadius: BorderRadius.circular(3),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                justCopied ? Icons.check : Icons.copy_all_outlined,
                size: 13,
                color: LPColor.rollerBlue_500,
              ),
              const SizedBox(width: 5),
              Text(
                justCopied ? 'Copied' : 'Copy',
                style: code.apply(
                  TextStyle(
                    color: LPColor.rollerBlue_500,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Inline code, as it appears mid-sentence.
///
/// A [TextStyle.backgroundColor] paints a tight rectangle flush against the
/// glyphs, which reads as a highlighter smudge rather than a code span. Drawing
/// the chip as its own box allows real horizontal padding and a rounded edge,
/// and [WidgetSpan] keeps it inline within the paragraph — and within the
/// enclosing selection.
class LPInlineCode extends StatelessWidget {
  final String content;

  const LPInlineCode({required this.content, super.key});

  /// The span form, for embedding in a [Text.rich] paragraph.
  static InlineSpan span(String content) => WidgetSpan(
        alignment: PlaceholderAlignment.middle,
        baseline: TextBaseline.alphabetic,
        child: LPInlineCode(content: content),
      );

  @override
  Widget build(BuildContext context) {
    LPViewport.of(context);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
      margin: const EdgeInsets.symmetric(horizontal: 1),
      decoration: BoxDecoration(
        color: LPColor.rollerBlue_500.withOpacity(0.15),
        borderRadius: BorderRadius.circular(3),
        border: Border.all(color: LPColor.rollerBlue_500.withOpacity(0.25)),
      ),
      child: Text(
        content,
        style: code.apply(
          TextStyle(
            color: LPColor.chaseRed_500,
            // Inline code sits inside running prose, so it has to be a touch
            // smaller than the body text or the line height jumps around it.
            fontSize: (code.apply().fontSize ?? 18) * 0.85,
          ),
        ),
      ),
    );
  }
}
