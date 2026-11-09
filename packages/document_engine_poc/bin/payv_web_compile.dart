import 'package:document_engine_poc/src/payv_specimen.dart';

void main() {
  // Referencing the entry point forces the compiler to resolve the complete
  // pure-Dart Payv renderer and its transitive dependencies for JavaScript.
  final generator = buildPayvSpecimen;
  if (generator.hashCode == 0) {
    throw StateError('Unreachable compile-time reference.');
  }
}
