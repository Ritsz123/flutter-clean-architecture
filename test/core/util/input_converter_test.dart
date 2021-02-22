import 'package:clean_flutter/core/util/input_converter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  InputConverter inputConverter;

  setUp(() {
    inputConverter = InputConverter();
  });

  group('string to unsigned int', () {
    test(
      'should return an integer when the string represents an unsigned integer',
      () {
        //arrange
        final str = "123";
        //act
        final result = inputConverter.stringToUnsignedInt(str);
        //assert
        expect(result, Right(123));
      },
    );

    test(
      'should return failure when string is not integer',
      () {
        //arrange
        final str = "123abc";
        //act
        final result = inputConverter.stringToUnsignedInt(str);
        //assert
        expect(result, Left(InvalidInputFailure()));
      },
    );

    test(
      'should return failure when string is negative integer',
      () {
        //arrange
        final str = "-123";
        //act
        final result = inputConverter.stringToUnsignedInt(str);
        //assert
        expect(result, Left(InvalidInputFailure()));
      },
    );
  });
}
