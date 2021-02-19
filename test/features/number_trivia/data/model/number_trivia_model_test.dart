import 'dart:convert';

import 'package:clean_flutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:clean_flutter/features/number_trivia/domain/entities/number_trivia.dart';
import 'package:flutter_test/flutter_test.dart';
import '../../../../fixtures/fixture_reader.dart';

void main() {
  final tNumberTriviaModel = NumberTriviaModel(number: 1, text: 'test text');

  test(
    'should be a subclass of number trivia entity',
    () async {
      //assert
      expect(tNumberTriviaModel, isA<NumberTrivia>());
    },
  );

  group(
    'from json',
    () {
      test(
        'should return a valid model when the JSON number is integer',
        () async {
          //  arrange
          final Map<String, dynamic> jsonMap = json.decode(
            fixture('trivia.json'),
          );
          // act
          final result = NumberTriviaModel.fromJson(jsonMap);
          //  assert
          expect(result, equals(tNumberTriviaModel));
        },
      );
      test(
        'should return a valid model when the JSON number is regarded as double',
        () async {
          //  arrange
          final Map<String, dynamic> jsonMap = json.decode(
            fixture('trivia_double.json'),
          );
          // act
          final result = NumberTriviaModel.fromJson(jsonMap);
          //  assert
          expect(result, equals(tNumberTriviaModel));
        },
      );
    },
  );

  group(
    'to json',
    () {
      test(
        'return a json map containing proper data',
        () async {
          //act
          final result = tNumberTriviaModel.toJson();

          //assert
          final expectedMap = {"text": "test text", "number": 1};
          expect(result, expectedMap);
        },
      );
    },
  );
}
