import 'dart:convert';

import 'package:clean_flutter/core/error/exceptions.dart';
import 'package:clean_flutter/features/number_trivia/data/datasources/number_trivia_local_data_source.dart';
import 'package:clean_flutter/features/number_trivia/data/models/number_trivia_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../fixtures/fixture_reader.dart';

class MockSharedPreferences extends Mock implements SharedPreferences {}

void main() {
  NumberTriviaLocalDataSourceImpl dataSource;
  MockSharedPreferences mockSharedPreferences;

  setUp(() {
    mockSharedPreferences = MockSharedPreferences();
    dataSource = NumberTriviaLocalDataSourceImpl(
      sharedPreferences: mockSharedPreferences,
    );
  });

  group('get last number trivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel.fromJson(json.decode(fixture('trivia_cache.json')));
    test(
        'should return numberTriviaModel from shared preferences when present in cache',
        () async {
      //  arrange
      when(mockSharedPreferences.getString(any))
          .thenReturn(fixture('trivia_cache.json'));
      //  act
      final result = await dataSource.getLastNumberTrivia();
      //  assert
      verify(mockSharedPreferences.getString(CACHED_NUMBER_TRIVIA));
      expect(result, equals(tNumberTriviaModel));
    });

    test(
      'should throw CacheException when there is no cache value',
      () async {
        //  arrange
        when(mockSharedPreferences.getString(any)).thenReturn(null);
        //  act
        final call = dataSource.getLastNumberTrivia;
        //  assert
        expect(() => call(), throwsA(TypeMatcher<CacheException>()));
      },
    );
  });

  group('cache number trivia', () {
    final tNumberTriviaModel =
        NumberTriviaModel(text: "test trivia", number: 1);
    test(
      'should call shared preferences to cache the data',
      () async {
        //  act
        dataSource.cacheNumberTrivia(tNumberTriviaModel);
        //  assert
        final expectedJson = json.encode(tNumberTriviaModel.toJson());
        verify(mockSharedPreferences.setString(
            CACHED_NUMBER_TRIVIA, expectedJson));
      },
    );
  });
}
