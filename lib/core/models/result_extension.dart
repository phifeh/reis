import 'package:reis/core/models/result.dart';

extension ResultExtension on Result {
  void when({
    required Function(dynamic) success,
    required Function(String, Exception?) failure,
  }) {
    if (this is Success) {
      success((this as Success).value);
    } else if (this is Failure) {
      final f = this as Failure;
      failure(f.message, f.exception);
    }
  }
}
