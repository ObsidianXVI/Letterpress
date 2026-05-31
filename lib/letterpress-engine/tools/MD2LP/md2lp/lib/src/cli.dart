import 'dart:io';

import 'package:args/command_runner.dart';

import 'generator.dart';

const int _successExitCode = 0;
const int _usageExitCode = 64;
const int _softwareExitCode = 70;

Future<int> runMd2Lp(
  List<String> args, {
  StringSink? stdoutSink,
  StringSink? stderrSink,
}) async {
  final StringSink out = stdoutSink ?? stdout;
  final StringSink err = stderrSink ?? stderr;
  final CommandRunner<int> runner = CommandRunner<int>(
    'md2lp',
    'Convert Letterpress markdown into LPModule and LPPost Dart declarations.',
  )
    ..addCommand(_GenerateModuleCommand(out))
    ..addCommand(_GeneratePostCommand(out));

  try {
    final int? exitCode = await runner.run(args);
    return exitCode ?? _successExitCode;
  } on UsageException catch (error) {
    err.writeln(error);
    return _usageExitCode;
  } catch (error) {
    err.writeln('Fatal error: $error');
    return _softwareExitCode;
  }
}

abstract class _Md2LpCommand extends Command<int> {
  final StringSink output;
  final MD2LPGenerator generator = MD2LPGenerator();

  _Md2LpCommand(this.output);

  DateTime requiredDate(String optionName) {
    final String? raw = argResults?[optionName] as String?;
    final DateTime? parsed = raw == null ? null : DateTime.tryParse(raw);
    if (parsed == null) {
      throw UsageException(
        'Invalid value for --$optionName. Expected YYYY-MM-DD.',
        usage,
      );
    }
    return parsed;
  }

  String requiredOption(String optionName) {
    final String? raw = argResults?[optionName] as String?;
    if (raw == null || raw.trim().isEmpty) {
      throw UsageException('Missing required --$optionName.', usage);
    }
    return raw.trim();
  }

  List<String> csvOption(String optionName) {
    final String raw = (argResults?[optionName] as String? ?? '').trim();
    if (raw.isEmpty) {
      return const <String>[];
    }
    return raw
        .split(',')
        .map((String value) => value.trim())
        .where((String value) => value.isNotEmpty)
        .toList();
  }

  TocMode tocMode() {
    return switch (argResults?['include-toc'] as String? ?? 'auto') {
      'true' => TocMode.enabled,
      'false' => TocMode.disabled,
      _ => TocMode.auto,
    };
  }

  Future<void> writeOutput(String content) async {
    final String? outputPath = argResults?['output'] as String?;
    if (outputPath == null || outputPath.trim().isEmpty) {
      output.writeln(content);
      return;
    }

    final File file = File(outputPath);
    await file.parent.create(recursive: true);
    await file.writeAsString(content);
    output.writeln('Wrote ${file.path}');
  }
}

class _GenerateModuleCommand extends _Md2LpCommand {
  _GenerateModuleCommand(super.output) {
    argParser
      ..addOption(
        'input',
        help: 'Path to the markdown source file to convert.',
      )
      ..addOption('title',
          help: 'Override the title inferred from the first line.')
      ..addOption('class-name',
          help: 'Override the generated LPModule class name.')
      ..addOption(
        'declaration-name',
        help: 'Override the generated top-level LPModule declaration name.',
      )
      ..addOption(
        'project-name',
        help: 'Project name passed into LPModule.',
        defaultsTo: '',
      )
      ..addOption(
        'publication-date',
        help: 'Publication date in YYYY-MM-DD.',
      )
      ..addOption(
        'last-update',
        help: 'Last update date in YYYY-MM-DD.',
      )
      ..addOption('cover-img-name', help: 'Optional cover image asset name.')
      ..addOption(
        'tags',
        help: 'Comma-separated tag list for the module.',
        defaultsTo: '',
      )
      ..addOption(
        'part-of',
        help: 'The Dart library name for the part-of directive.',
        defaultsTo: 'letterpress.store',
      )
      ..addOption(
        'include-toc',
        allowed: const <String>['auto', 'true', 'false'],
        defaultsTo: 'auto',
        help:
            'Whether the generated module should include a table of contents.',
      )
      ..addFlag(
        'preview',
        defaultsTo: false,
        help: 'Emit the top-level module declaration in preview mode.',
      )
      ..addFlag(
        'emit-declaration',
        defaultsTo: true,
        help: 'Emit a top-level LPModule declaration after the class.',
      )
      ..addOption(
        'output',
        help: 'Optional file path to write instead of stdout.',
      );
  }

  @override
  String get name => 'module';

  @override
  String get description =>
      'Generate an LPModule class and optional LPModule declaration from markdown.';

  @override
  Future<int> run() async {
    final File inputFile = File(requiredOption('input'));
    if (!await inputFile.exists()) {
      throw UsageException('Input file not found: ${inputFile.path}', usage);
    }

    final ModuleGenerationResult result = generator.generateModule(
      ModuleGenerationRequest(
        source: await inputFile.readAsString(),
        title: argResults?['title'] as String?,
        className: argResults?['class-name'] as String?,
        declarationName: argResults?['declaration-name'] as String?,
        projectName: argResults?['project-name'] as String? ?? '',
        publicationDate: requiredDate('publication-date'),
        lastUpdate: requiredDate('last-update'),
        coverImgName: argResults?['cover-img-name'] as String?,
        tags: csvOption('tags'),
        previewMode: argResults?['preview'] as bool? ?? false,
        partOfLibrary: argResults?['part-of'] as String? ?? 'letterpress.store',
        tocMode: tocMode(),
        emitDeclaration: argResults?['emit-declaration'] as bool? ?? true,
      ),
    );

    await writeOutput(result.fileContent);
    return _successExitCode;
  }
}

class _GeneratePostCommand extends _Md2LpCommand {
  _GeneratePostCommand(super.output) {
    argParser
      ..addOption('title', help: 'Post title.')
      ..addOption('description', help: 'Post description.')
      ..addOption(
        'publication-date',
        help: 'Publication date in YYYY-MM-DD.',
      )
      ..addOption(
        'last-update',
        help: 'Last update date in YYYY-MM-DD.',
      )
      ..addOption(
        'blogules',
        help: 'Comma-separated list of blogule declaration identifiers.',
      )
      ..addOption(
        'declaration-name',
        help: 'Override the generated LPPost declaration name.',
      )
      ..addFlag(
        'preview',
        defaultsTo: false,
        help: 'Mark the generated LPPost declaration as preview mode.',
      )
      ..addOption(
        'output',
        help: 'Optional file path to write instead of stdout.',
      );
  }

  @override
  String get name => 'post';

  @override
  String get description => 'Generate an LPPost declaration.';

  @override
  Future<int> run() async {
    final String postDeclaration = generator.generatePostDeclaration(
      PostGenerationRequest(
        title: requiredOption('title'),
        description: requiredOption('description'),
        publicationDate: requiredDate('publication-date'),
        lastUpdate: requiredDate('last-update'),
        bloguleDeclarations: csvOption('blogules'),
        declarationName: argResults?['declaration-name'] as String?,
        previewMode: argResults?['preview'] as bool? ?? false,
      ),
    );

    await writeOutput(postDeclaration);
    return _successExitCode;
  }
}
