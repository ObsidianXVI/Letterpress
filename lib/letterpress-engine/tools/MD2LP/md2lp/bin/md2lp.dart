import 'dart:io';

import 'package:md2lp/md2lp.dart';

Future<void> main(List<String> args) async {
  final int exitCode = await runMd2Lp(args);
  if (exitCode != 0) {
    exit(exitCode);
  }
}
