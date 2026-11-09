import 'dart:convert';
import 'dart:io';

import 'package:document_engine_poc/src/harfbuzz_specimen.dart';
import 'package:document_engine_poc/src/payv_specimen.dart';
import 'package:document_engine_poc/src/plain_pdf_specimen.dart';

Future<void> main(List<String> args) async {
  final outputPath = args.isEmpty ? 'build/poc-artifacts' : args.first;
  final output = Directory(outputPath);
  await output.create(recursive: true);

  final ibm = await File('assets/fonts/IBMPlexSansArabic-Regular.ttf').readAsBytes();
  final vazir = await File('assets/fonts/Vazirmatn-Regular.ttf').readAsBytes();

  final candidates = <String, Future<List<int>> Function()>{
    'candidate-a-plain-pdf.pdf': () => buildPlainPdfSpecimen(ibm),
    'candidate-b-harfbuzz-pdf-text-shaper.pdf': () => buildHarfBuzzSpecimen(
      arabicFontBytes: ibm,
      fallbackFontBytes: vazir,
    ),
    'candidate-d-payv-pure-dart.pdf': () async => buildPayvSpecimen(ibm),
  };

  final measurements = <Map<String, Object>>[];
  var failedCandidates = 0;

  for (final entry in candidates.entries) {
    final timer = Stopwatch()..start();
    try {
      final bytes = await entry.value();
      timer.stop();
      if (bytes.length < 5 ||
          bytes[0] != 37 ||
          bytes[1] != 80 ||
          bytes[2] != 68 ||
          bytes[3] != 70 ||
          bytes[4] != 45) {
        throw StateError('Generator returned bytes without a PDF signature.');
      }

      await File('${output.path}/${entry.key}').writeAsBytes(bytes, flush: true);
      measurements.add(<String, Object>{
        'file': entry.key,
        'status': 'success',
        'bytes': bytes.length,
        'elapsed_microseconds': timer.elapsedMicroseconds,
        'pdf_signature_valid': true,
      });
    } catch (error) {
      timer.stop();
      failedCandidates++;
      measurements.add(<String, Object>{
        'file': entry.key,
        'status': 'failed',
        'elapsed_microseconds': timer.elapsedMicroseconds,
        'error': error.toString(),
      });
      stderr.writeln('Candidate ${entry.key} failed: $error');
    }
  }

  final report = <String, Object>{
    'purpose': 'Synthetic Arabic PDF POC; not production evidence',
    'runtime': Platform.operatingSystem,
    'successful_candidates': candidates.length - failedCandidates,
    'failed_candidates': failedCandidates,
    'candidates': measurements,
    'manual_visual_review_required': true,
    'text_extraction_is_not_visual_acceptance': true,
  };
  await File('${output.path}/generation_report.json').writeAsString(
    const JsonEncoder.withIndent('  ').convert(report),
    flush: true,
  );

  if (failedCandidates > 0) {
    stderr.writeln('$failedCandidates candidate PDF generator(s) failed.');
    exitCode = 1;
  }
}
