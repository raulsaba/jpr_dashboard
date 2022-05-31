import 'package:dartz/dartz.dart';
import 'package:flutter_jpr_dashboard/core/error/failure.dart';
import 'package:flutter_jpr_dashboard/core/util/input_converter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  late InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('Input Converter', () {
    group("stringToUnsignedInt", () {
      test(
        "should retunr an Integer when the String represents an unsigned Integer",
        () async {
          const str = '123';
          final result = inputConverter.stringToUnsignedInteger(str);
          expect(result, const Right(123));
        },
      );

      test(
        "should return a Failure when the String is not an Integer",
        () async {
          const str = 'abc';
          final result = inputConverter.stringToUnsignedInteger(str);
          expect(result, Left(InvalidInputFailure()));
        },
      );

      test(
        "should return a Failure when the String is a negative Integer",
        () async {
          const str = '-123';
          final result = inputConverter.stringToUnsignedInteger(str);
          expect(result, Left(InvalidInputFailure()));
        },
      );
    });
  });
}
